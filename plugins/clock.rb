class Pinion::Plugins::Clock < Pinion::Plugins::Default
  def add
    @label = Gtk::Label.new
    Panel.add @label
    Run.every 1.second do
      @label.set_markup Time.new.strftime(@config.format)
    end
  end
end