class Pinion::Plugins::Clock
  def add
    @label = Gtk::Label.new
    ::Pinion.panel.add(@label)
    ::Pinion.timer 1.second do
      @label.set_markup Time.new.strftime(Configru.time_format)
    end
  end

  def self.remove
    #::Pinion.unload(self)
  end
end