# Path to root of plugin dir
plugin_root = File.join(File.dirname(__FILE__), '..', '..', '..')
$:.unshift(File.join(plugin_root, 'lib'))

RAILS_ENV = 'test'
RAILS_ROOT = File.join(plugin_root, 'test', 'iq', 'storage', 'rails_root')

# Use vendor rails if possible
if File.directory?(rails_dir = File.join(plugin_root, '..', '..', 'rails'))
  %w(activerecord actionpack activesupport actionmailer).each { |dir| $:.unshift File.join(rails_dir, dir, 'lib') }
end

# Gems used for testing
require 'test/unit'
require 'rubygems'
require 'redgreen'

# Parts of rails used
require 'active_support'
require 'logger'
RAILS_DEFAULT_LOGGER = Logger.new(STDERR)

# Initialize the plugin
require 'iq/storage'
require File.join(plugin_root, 'init')

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    saved_protected_instance_methods = self.protected_instance_methods
    self.class_eval { public *saved_private_instance_methods + saved_protected_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
    self.class_eval { protected *saved_protected_instance_methods }
  end
end

module Factory
  # Base
  # ----
  def self.new_valid_base_adapter(assigns = {})
    new_base_adapter({}.merge(assigns))
  end
  
  def self.new_base_adapter(*args)
    IQ::Storage::Adapters::Base.new(*args)
  end
  
  # Fs
  # --
  def self.new_valid_fs_adapter(assigns = {})
    new_fs_adapter({}.merge(assigns))
  end
  
  def self.new_fs_adapter(*args)
    IQ::Storage::Adapters::Fs.new(*args)
  end
  
  # s3
  # --
  def self.new_valid_s3_adapter(assigns = {})
    new_s3_adapter({}.merge(assigns))
  end
  
  def self.new_s3_adapter(*args)
    IQ::Storage::Adapters::S3.new(*args)
  end
  
  def self.adapter_registry_enabled_class
    Class.new do
      include IQ::Storage::AdapterRegistry
    end
  end
  
  private
  
  def self.build_class(classified)
    Object.__send__(:remove_const, classified) if Object.const_defined?(classified)
    Object.const_set(classified, Class.new)
  end
end