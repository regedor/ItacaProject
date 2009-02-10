module IQ::Upload::Extensions::ActiveRecord
  # Options:
  # * <tt>:storage</tt> - (optional) storage adapter to use - defaults to :fs
  # * <tt>:backgroundrb</tt> - (optional) process images using backgroundrb. defaults to false
  # * <tt>:dir</tt> - (optional) path from RAILS_ROOT to store uploaded files. Defaults to 'public/assets/my_model'
  #
  def uploadify(options = {})
    raise ArgumentError, 'Options must be supplied as a hash' unless options.is_a?(Hash)
    options.assert_valid_keys(:storage, :dir, :backgroundrb)
    
    unless self.column_names.include?('filename')
      raise ::IQ::Upload::Exceptions::NoFileColumnError, 'filename column is mandatory'
    end
    raise ArgumentError, 'Storage must be a Symbol' if options.key?(:storage) && !options[:storage].is_a?(Symbol)
    raise ArgumentError, ':dir must be a String' if options.key?(:dir) && !options[:dir].is_a?(String)
    
    unless included_modules.include? ::IQ::Upload::Base
      # TODO: move to base??
      attr_accessor :temp_path
      attr_protected :filename

      include ::IQ::Upload::Base
      include ::IQ::Upload::Backgroundrb if options[:backgroundrb].eql?(true)
      include ::IQ::Upload::MetaDataAccessors

      storage_adapter_name  = (options[:storage] ||= IQ::Upload::Config.default_storage_adapter)
      storage_adapter_proc  = ::IQ::Upload::Config.storage_adapters[storage_adapter_name]
      raise ArgumentError, ':storage option must be a registered storage adapter' if storage_adapter_proc.nil?
      @uploadify_storage_adapter = storage_adapter_proc
      
      class << self
        attr_reader :uploadify_storage_adapter
      end
      
      write_inheritable_attribute :uploadify_options, options

      after_save    :store_upload
      after_destroy :remove_from_storage
    end
  end
  
  module TableDefinition
    # todo rdocs...
#    def asset_columns(options = {})
#      options.assert_valid_keys(:versions, :metadata)
#      column(:string, :filename)
#      if options[:versions]
#        column(:string, :version_name)
#        column(:integer, :base_version_id)
#      end
#      if options[:metadata]
#        column(:string, :content_type)
#        column(:integer, :width, :height, :file_size)
#      end
#    end

    # todo all kinds of examples... 
    # t.asset_columns(:versions => true, :metadata => true)

    #  t.column :base_version_id, :integer
    #  t.column :version_name,    :string
    #  t.column :filename,        :string, :limit => 255
    #  t.column :content_type,    :string, :limit => 255
    #  t.column :file_size,       :integer
    #  t.column :width,           :integer
    #  t.column :height,          :integer
  end
end