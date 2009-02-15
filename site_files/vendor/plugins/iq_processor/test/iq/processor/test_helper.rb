# Path to root of plugin dir
PLUGIN_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..')
$:.unshift(File.join(PLUGIN_ROOT, 'lib'))

RAILS_ENV = 'test'
RAILS_ROOT = File.join(PLUGIN_ROOT, 'test', 'iq', 'processor', 'rails_root')

# Use vendor rails if possible
if File.directory?(rails_dir = File.join(PLUGIN_ROOT, '..', '..', 'rails'))
  %w(activerecord actionpack activesupport actionmailer).each { |dir| $:.unshift File.join(rails_dir, dir, 'lib') }
end

# Gems used for testing
require 'test/unit'
require 'rubygems'
require 'redgreen'

# Parts of rails used
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_controller/test_process'
require 'logger'
RAILS_DEFAULT_LOGGER = Logger.new(STDERR)

# Plugin Dependencies
$:.unshift File.join(PLUGIN_ROOT, '..', 'iq_storage', 'lib')
require 'iq/storage'

# Initialize the plugin
require 'iq/processor'

module Factory
  # BasicAsset
  # ----------
  def self.basic_asset_class
    build_active_record_class('BasicAsset')
  end
  
  def self.basic_asset_class_with_process
    build_active_record_class('BasicAsset')
    BasicAsset.process() {}
    BasicAsset
  end
  
  # MetaDataAsset
  # -------------
  def self.meta_data_asset_class
    build_active_record_class('MetaDataAsset')
  end
  
  private
  
  def self.build_active_record_class(classified)
    Object.__send__(:remove_const, classified) if Object.const_defined?(classified)
    Object.const_set(classified, Class.new(ActiveRecord::Base))
  end
end

# Assertions and helper methods
class Test::Unit::TestCase
  def flunk(text = nil)
    print "\033[0;33mP\033[0m"
  end
end