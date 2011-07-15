#!/usr/bin/env ruby

$: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))

require 'configru'
require 'gtk2'

class Pinion
  def initialize
    @@timer = Timer.new
    @@panel = Panel.new
    load_plugins
  end

  def load_plugins
    Configru.plugins.each do |plugin|
      Pinion::Plugins.load(plugin)
    end
    ::Pinion.panel.show_all
  end

  # Ew hacks D:
  def self.panel; @@panel; end
  def self.timer; @@timer; end
end

require 'lib/panel'
require 'lib/timer'
require 'lib/plugins'
require 'plugins/default'

Pinion.new
Gtk.main