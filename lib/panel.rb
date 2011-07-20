begin
  require 'rubygems'
  require 'color'
rescue
  warn "Please install the 'color' gem"
end

class Pinion::Panel < Gtk::Window
  def initialize
    super('Pinion')
    load_config

    @transparent = nil
    @rgb = [1.0, 1.0, 1.0]
    @opacity = Configru.opacity

    # Not sure if I should go for _DOCK or _DESKTOP
    self.type_hint = Gdk::Window::TYPE_HINT_DOCK
    self.stick
    self.accept_focus = false
    self.gravity = Gdk::Window::GRAVITY_NORTH_EAST # Not sure if this actually does anything
    self.height_request = Configru.height

    # app_paintable's value is false if we use the GTK theme,
    #\ and true otherwise
    self.app_paintable = !Configru.gtk_theme

    if self.screen.composited? && Configru.transparent
      # Use RGBA colormap if transparency is enabled
      self.colormap = self.screen.rgba_colormap
      @transparent = true
    else
      # Screen is not ocmposited, use RBG colormap
      self.colormap = self.screen.rgb_colormap
      @transparent = false
    end

    # Signals
    self.signal_connect('check-resize') {realign}
    self.signal_connect('expose-event') {|w, e| draw(w, e); false}

    # Set up HBox
    @@hbox = Gtk::HBox.new(false, Configru.spacing)
    self.add(@@hbox)
  end

  # Hackkkk D:
  def hbox
    @@hbox
  end

  def realign
    self.move(self.screen.width - self.size[0], 0)
  end

  def draw(w, e)
    c = w.window.create_cairo_context
    if @transparent
      c.set_source_rgba(@rgb[0], @rgb[1], @rgb[2], @opacity)
    else
      c.set_source_rgb(@rgb[0], @rgb[1], @rgb[2])
    end
    c.operator = Cairo::OPERATOR_SOURCE
    c.paint
  end


  def load_config
    Configru.load do
      cascade '~/.pinion.yml', '~/.config/pinion/config.yml', '/etc/pinion/config.yml'
      defaults do
        height      24
        transparent true
        time_format "%a %b %d, %I:%M:%S %p" # "Thu Jul 14, 07:40:50 PM"
        spacing     10 # Default to 10px spacing between each item
        use_gtk     true
        plugins     ['clock']
      end
      
      verify do
        height      Fixnum
        transparent [true, false]
        time_format String
        spacing     Numeric
        use_gtk     [true, false]
        plugins     Array
      end
    end
  end
end