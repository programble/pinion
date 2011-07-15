class Pinion::Plugins
  def self.load(plugin)
    @@plugins ||= {}
    
    if File.file?(File.join(File.dirname(__FILE__), '..', 'plugins', "#{plugin}.rb"))
      plugin.downcase!
      Kernel.load "plugins/#{plugin}.rb"
      @@plugins[plugin] = ::Pinion::Plugins.const_get(plugin.capitalize).new
      @@plugins[plugin].add
    else
      warn "Plugin `#{plugin}' does not exist!"
    end
  end
end