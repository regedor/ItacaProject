module IQ::Storage::Adapters
  # Base class for Storage Storage Engines.
  # Storage Engines determine how/where uploaded files are stored (Eg local file system, database, remote web service etc...)
  class RemoteBase < Base
#    class_inheritable_accessor :fs_adapter
#
#    def initialize(asset_class)
#      super(asset_class)
#      self.fs_adapter = Fs.new(asset_class)
#    end
#
#    def store(model_instance)
#      self.fs_adapter.store(model_instance)
#      persist_to_remote_storage(model_instance)
#    end
#
#    def persist_to_remote_storage(model_instance)
#      raise IQ::Storage::Exceptions::AbstractMethodError.new("Abstract Method - please override.")
#    end
#    
#    def erase(model_instance)
#      remove_from_remote_storage(model_instance)
#      self.fs_adapter.erase(model_instance)
#    end
#    
#    def remove_from_remote_storage(model_instance)
#      raise IQ::Storage::Exceptions::AbstractMethodError.new("Abstract Method - please override.")
#    end

    # Returns true as this is a remote storage engine
#    def persists_remotely?
#      true
#    end
  end
end