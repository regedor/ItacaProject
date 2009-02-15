# Assumes that the model has the following methods:
#
# * storage_path => returns a path relative to storage adapter's base path to which files are stored
# * temp_path => returns a temporary path to a file that needs processing
# 

module IQ::Processor::Base
  def self.included(base)
    base.with_options :foreign_key => 'base_version_id' do |with|
      with.has_many :versions, :class_name => base.name, :dependent => :destroy do
        # Defined on the has_many :versions association proxy
        def [](version_name)
          # TODO: could somehow determine if this association has been eagerly
          # loaded and use 'detect' if it has, otherwise use:
          #   self.find_by_version_name(version_name.to_s)
          # 
          # This way the detect saves on queries, but there is also the option
          # to load the db when needed e.g. if there are loads of versions.
          version_name = version_name.to_s
          
          unless proxy_owner.class.version_handlers.keys.include?(version_name)
            raise ActiveRecord::RecordNotFound, "There is no version called '#{version_name}'"
          end
          
          version = detect { |asset| asset.version_name.eql?(version_name) } || build(:version_name => version_name)
          version.base_version = proxy_owner # This stops an additional query
          version.save if proxy_owner.requires_storage? || version.new_record?
          
          # TODO: Should probably do the following instead of the line above
          # version.save if !proxy_owner.new_record? && (proxy_owner.requires_storage? || version.new_record?)
          
          version
        end
      end
      with.belongs_to :base_version, :class_name => base.name
    end
    
    base.before_save  :process_base_version
    base.before_save  :process_versions
    base.after_save   :generate_versions
    
    base.extend ClassMethods
  end
  
  module ClassMethods
#    # Reprocess all assets. Useful when you change the :conversions configuration on your model and want
#    # existing assets to match the new config.
#    #   MyAsset.reprocess_all_assets
#    def reprocess_all_assets
#      if column_names.include?('base_version_id')
#        self.find(:all, :conditions => {:base_version_id => nil}).each do |asset_record|
#          asset_record.reprocess_asset
#        end
#      end
#    end
  end

  def base_version?
    self.base_version_id.nil?
  end

  def process_base_version
    return unless base_version? && temp_path && (version_handler = self.class.base_version_handler)
    version_handler.process(self, temp_path)
  end
  
  def process_versions
    return if base_version? || base_version.new_record? || !(version_handler = self.class.version_handlers[version_name])
    
    storage_adapter.with_temp_file do |tempfile|
      base_version.storage_adapter.fetch(base_version.storage_path, tempfile.path)
      version_handler.process(self, tempfile.path)
      storage_adapter.store(tempfile.path, storage_path)
    end
  end
  
  def generate_versions
    return unless base_version? && requires_storage?
    self.class.version_handlers.keys.map(&:to_s).each { |name| versions[name] }
  end
  
  def instance_dir
    base_version? ? super : base_version.instance_dir
  end
  
  def storage_adapter
    return super if base_version? rescue NoMethodError
    return @process_storage_adapter if @process_storage_adapter
    version_handler = self.class.version_handlers[version_name.to_s]
    @process_storage_adapter = if (proc = (version_handler && version_handler.storage_adapter))
      proc.call
    else
      if base_version?
        #IQ::Processor::Config.default_storage_proc.call
        IQ::Processor::Config.storage_adapters[IQ::Processor::Config.default_storage_adapter].call
      else
        base_version.storage_adapter
      end
    end
  end

  # Returns the absolute base directory that storage_adapter should use on initialisation
  def asset_dir
    version_handler = base_version? ? self.class.base_version_handler : self.class.version_handlers[version_name]
    return (version_handler && version_handler.storage_dir) || super rescue NoMethodError
    IQ::Processor::Config.default_storage_dir
  end
end
