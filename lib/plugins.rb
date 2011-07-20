class Pinion::Plugins
  def self.load(plugin)
    @@plugins ||= []

    if File.file?(File.join(File.dirname(__FILE__), '..', 'plugins', "#{plugin['type']}.rb"))
      Kernel.load "plugins/#{plugin['type']}.rb"
      @@plugins << ::Pinion::Plugins.const_get(plugin['type'].downcase.capitalize).new

      config = Configru::ConfigHash.new(plugin) # Eurgh!
      @@plugins[-1].configure(config)
      @@plugins[-1].add
    else
      warn "Plugin `#{plugin}' does not exist!"
    end
  end
end