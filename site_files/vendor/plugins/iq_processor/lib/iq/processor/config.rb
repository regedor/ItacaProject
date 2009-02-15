module IQ::Processor::Config
  @default_storage_dir  = File.join('public', 'assets')
  @tempfile_path        = File.join(RAILS_ROOT, 'tmp', 'uploads')
  @adapters             = {}
  
  class << self
    attr_accessor :default_storage_dir, :tempfile_path
    attr_reader :adapters, :default_adapter
  end
  
  # Used to set default adapter for all processor models. (:iq_image by default)
  #    IQ::Processer::Config.default_adapter = :iq_image
  # Adapter can still be overridden on a class by class basis
  #    class MyDBAsset < ActiveRecord::Base
  #      process :adapter => :iq_image
  #    end
  def self.default_adapter=(adapter)
    unless IQ::Processor::Config.adapters.keys.include?(adapter)
      raise IQ::Processor::Exceptions::UnregisteredAdapterError, "No Adapter Registered for #{adapter}"
    end
    @default_adapter = adapter
  end
  
  def self.register_adapter(name, klass)
    raise ArgumentError, 'Name must be a Symbol' unless name.is_a? Symbol
    adapters[name] = klass
  end
  
  include IQ::Storage::AdapterRegistry
end

# Storage Adapters
# ----------------
IQ::Processor::Config.register_storage_adapter(:fs) do 
  IQ::Storage::Adapters::Fs.new(:absolute_base => RAILS_ROOT, :relative_base => File.join(RAILS_ROOT, 'public'))
end
IQ::Processor::Config.register_storage_adapter(:s3) { IQ::Storage::Adapters::S3.new }
IQ::Processor::Config.register_storage_adapter(:db) { IQ::Storage::Adapters::Db.new }
IQ::Processor::Config.default_storage_adapter = :fs

# Processor Adapters
# ------------------
IQ::Processor::Config.register_adapter :iq_image,     IQ::Processor::Adapters::IqImage
IQ::Processor::Config.register_adapter :rmagick,      IQ::Processor::Adapters::Rmagick
IQ::Processor::Config.register_adapter :mini_magick,  IQ::Processor::Adapters::MiniMagick
IQ::Processor::Config.default_adapter = :iq_image

#begin
#  IQ::Processor::Config.register_storage_adapter(:s3, )
#rescue LoadError
#end