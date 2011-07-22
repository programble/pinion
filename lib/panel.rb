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
    @opacity = Configru.opacity

    begin
      if Configru.background.is_a?(Array)
        # Array of [red, green, blue]
        @rgb = Configru.background
      elsif Configru.background.is_a?(String)
        # HTML hex code, such as #FFF or #ABCDEF
        if Configru.background[0,1] == '#'
          @rgb = Color::RGB.from_html(Configru.background)
        else
          @rgb = Color::RGB.const_get(Configru.background.delete(' '))
        end
      else
        raise # Hackish? Maybe. Oh well.
      end
    rescue
      warn "Invalid background color specified!\n"
      warn "The `background' configuration option can be defined in 3 ways:"
      warn "1) Array: [red, green, blue]  (ie, [1.0, 1.0, 1.0] for white)"
      warn "2) Hex value: #ABCDEF (ie, #FFF or #FFFFFF for white)"
      warn "3) One of the names mentioned on http://en.wikipedia.org/wiki/X11_color_names#Color_name_charts"
      warn "   Capitalization of color names matter, spacing does not!"
      exit
    end

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
    width, height = self.size
    case Configru.position
    when 'top-left'
      self.move(0, 0)
    when 'top-right'
      self.move(self.screen.width - width, 0)
    when 'bottom-left'
      self.move(0, self.screen.height - height)
    when 'bottom-right'
      self.move(self.screen.width - width, self.screen.height - height)
    end
  end

  def draw(w, e)
    c = w.window.create_cairo_context
    if @transparent
      c.set_source_rgba(@rgb.red, @rgb.green, @rgb.blue, @opacity)
    else
      c.set_source_rgb(@rgb.red, @rgb.green, @rgb.blue)
    end
    c.operator = Cairo::OPERATOR_SOURCE
    c.paint
  end

  def load_config
    Configru.load do
      cascade '~/.pinion.yml', '~/.config/pinion/config.yml', '/etc/pinion/config.yml'
      defaults File.join(File.dirname(__FILE__), '..', 'config.yml.dist')

      verify do
        height      Fixnum
        position    ['top-left', 'top-right', 'bottom-left', 'bottom-right']
        transparent [true, false]
        opacity     Numeric
        background  String
        spacing     Numeric
        use_gtk     [true, false]
        plugins     Array
      end
    end
  end
end
