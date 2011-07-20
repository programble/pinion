class Pinion::Plugins::Default
  attr_accessor :config
  @config = nil

  def configure(config)
    @config = config
  end

  class Panel
    def self.add(item)
      ::Pinion.panel.hbox.pack_end(item)
      ::Pinion.panel.show_all
    end
  end

  class Run
    def self.every(interval, thread = false, &handler)
      ::Pinion.timer.add(interval, thread, &handler)
    end
  end
end