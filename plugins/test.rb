class Pinion::Plugins::Test < Pinion::Plugins::Default
  def add
    @label = Gtk::Label.new
    Panel.add @label
    Run.every 10.second do
      @label.text = "Test!"
    end
  end
end