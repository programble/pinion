class Pinion::Panel < Gtk::Window
  def initialize
    super('Pinion')
    load_config

    # Not sure if I should go for _DOCK or _DESKTOP
    self.type_hint = Gdk::Window::TYPE_HINT_DOCK
    self.stick
    self.accept_focus = false
    self.gravity = Gdk::Window::GRAVITY_NORTH_EAST # Not sure if this actually does anything
    self.height_request = Configru.height

    if self.screen.composited? && Configru.transparent
      # Screen is composited and transparency is enabled, use transparency
      self.app_paintable = true
      self.colormap = self.screen.rgba_colormap
    else
      # Screen is not composited, use normal GTK them
      self.app_paintable = false # Use GTK theme(?)
      self.colormap = self.screen.rgb_colormap
    end

    # Signals
    self.signal_connect('check-resize') {realign}
    self.signal_connect('expose-event') {|w, e| draw(w, e); false}
  end

  def realign
    self.move(self.screen.width - self.size[0], 0)
  end

  def draw(w, e)
    c = w.window.create_cairo_context
    c.set_source_rgba(1.0, 1.0, 1.0, 0.0)
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
        plugins     ['clock']
      end
      
      verify do
        height      Fixnum
        transparent [true, false]
        time_format String
        plugins     Array
      end
    end
  end
end