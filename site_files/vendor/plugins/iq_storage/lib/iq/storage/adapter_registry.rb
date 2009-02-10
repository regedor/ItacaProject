module IQ::Storage::AdapterRegistry
  def self.included(base)
    base.extend ClassMethods
    base.module_eval do
      @storage_adapters = {}
    end
  end
  
  module ClassMethods
    attr_reader :default_storage_adapter, :storage_adapters
    
    # Sets the storage adapter to be used by default.
    def default_storage_adapter=(adapter)
      unless storage_adapters.keys.include?(adapter)
        raise Exceptions::UnregisteredAdapterError, "No Storage Adapter Registered for #{adapter}"
      end
      @default_storage_adapter = adapter
    end

    # Allows a storage adapter to be registered by supplying a name
    # (usually a Symbol) and a block which when called should return a storage
    # adaptor instance with any neccessary defaults.
    # 
    # Example:
    #   register_storage_adapter(:fs) { IQ::Storage::Adapters::Fs.new(:absolute_base => '/my/dir') }
    def register_storage_adapter(name, &block)
      raise ArgumentError, 'Must supply block' unless block_given?
      storage_adapters[name] = block
    end
  end
  
  module Exceptions
    class UnregisteredAdapterError < StandardError; end
  end
end