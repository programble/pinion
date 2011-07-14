#!/usr/bin/env ruby

require 'gtk2'

class Panel < Gtk::Window
  def initialize
    super('Pinion')

    # Not sure if I should go for _DOCK or _DESKTOP
    self.type_hint = Gdk::Window::TYPE_HINT_DOCK
    self.stick
    self.accept_focus = false
    self.gravity = Gdk::Window::GRAVITY_NORTH_EAST # Not sure if this actually does anything
    self.height_request = 24 # TODO: Don't hardcode 24

    # Transparent background related
    # TODO: Disable transparency based on self.screen.composited?
    self.app_paintable = true
    self.colormap = self.screen.rgba_colormap

    # Signals
    self.signal_connect('check-resize') {realign}
    self.signal_connect('expose-event') {|w, e| draw(w, e); false}

    label = Gtk::Label.new(Time.new.to_s)
    self.add(label)
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
end

panel = Panel.new
panel.show_all
Gtk.main
