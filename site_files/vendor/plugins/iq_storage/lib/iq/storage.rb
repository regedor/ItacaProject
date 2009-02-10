require 'fileutils'

module IQ # :nodoc:
  module Storage # :nodoc:
    module Adapters
      autoload :Base,       File.join(File.dirname(__FILE__), 'storage', 'adapters', 'base')
      autoload :RemoteBase, File.join(File.dirname(__FILE__), 'storage', 'adapters', 'remote_base')
      autoload :Fs,         File.join(File.dirname(__FILE__), 'storage', 'adapters', 'fs')
      autoload :S3,         File.join(File.dirname(__FILE__), 'storage', 'adapters', 's3')
      autoload :Db,         File.join(File.dirname(__FILE__), 'storage', 'adapters', 'db')
    end
    
    autoload :AdapterRegistry, File.join(File.dirname(__FILE__), 'storage', 'adapter_registry')
  end
end