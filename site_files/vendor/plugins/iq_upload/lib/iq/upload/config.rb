module IQ::Upload::Config
  @default_storage_dir      = File.join('public', 'assets')
  @tempfile_path            = File.join(RAILS_ROOT, 'tmp', 'uploads')

  class << self
    attr_accessor :default_storage_dir, :tempfile_path
  end

  include IQ::Storage::AdapterRegistry
end

IQ::Upload::Config.register_storage_adapter(:fs) do 
  IQ::Storage::Adapters::Fs.new(
    :absolute_base => RAILS_ROOT,
    :relative_base => File.join(RAILS_ROOT, 'public')
  )
end
IQ::Upload::Config.register_storage_adapter(:s3) { IQ::Storage::Adapters::S3.new }
IQ::Upload::Config.register_storage_adapter(:db) { IQ::Storage::Adapters::Db.new }

IQ::Upload::Config.default_storage_adapter = :fs