class IQ::Processor::VersionHandler
  
  attr_reader :process_proc, :storage_adapter, :adapter, :storage_dir, :format, :basename
  
  def initialize(options = {}, &block)
    
    raise ArgumentError, 'Options must be supplied in a hash' unless options.is_a?(Hash)
    raise ArgumentError, 'Block must be supplied' unless block_given?
    options.assert_valid_keys :storage, :adapter, :dir, :format, :basename
    
    storage_adapter   = options.delete(:storage)
    processor_adapter = options.delete(:adapter)
    storage_dir       = options.delete(:dir)
    basename          = options.delete(:basename)
    format            = options.delete(:format)
    unless storage_adapter.nil? || storage_adapter.is_a?(Symbol) || storage_adapter.is_a?(Proc)
      raise ArgumentError, ':storage option must be a Symbol representing a registered storage adapter or a Proc'
    end
    
    @storage_adapter = if storage_adapter.is_a?(Symbol)
      IQ::Processor::Config.storage_adapters[storage_adapter] || raise(IQ::Processor::Exceptions::UnregisteredAdapterError, "#{storage_adapter} is not a valid storage adapter")
    else
      storage_adapter
    end
    
    unless processor_adapter.nil? || processor_adapter.is_a?(Symbol)
      raise ArgumentError, ':adapter option must be a Symbol representing a registered processor adapter'
    end
    
    @adapter = IQ::Processor::Config.adapters[processor_adapter || IQ::Processor::Config.default_adapter] || raise(IQ::Processor::Exceptions::UnregisteredAdapterError, "#{processor_adapter} is not a valid processor adapter")
    
    unless storage_dir.nil? || storage_dir.is_a?(String)
      raise ArgumentError, ':dir option must be a string'
    end
    
    @storage_dir = storage_dir

    # TODO: test this!!!
    unless format.nil? || format.is_a?(Symbol) || format.is_a?(String) || format.is_a?(Proc)
      raise ArgumentError, ':format option must be a Symbol, String or a Proc'
    end
    
    @format = format

    # TODO: test this!!!
    unless basename.nil? || basename.is_a?(Symbol) || basename.is_a?(String) || basename.is_a?(Proc)
      raise ArgumentError, ':basename option must be a Symbol, String or a Proc'
    end
    
    @basename = basename

    
    @process_proc = block
  end
  
  # TODO: Test
  def process(model_instance, temp_path)
    format_extension = case format
      when String : format
      when Symbol : model_instance.send(format)
      when Proc   : model_instance.instance_eval(&format)
      else nil
    end
    
    adapter_instance = adapter.new(model_instance, temp_path, format_extension, &process_proc)
    adapter_instance.write
    
    file_basename = case basename
      when String : basename
      when Symbol : model_instance.send(basename)
      when Proc   : model_instance.instance_eval(&basename)
      else nil
    end
    
    if model_instance.base_version?
      original = model_instance.filename
      extension = File.extname(original)
      new_filename = file_basename || File.basename(original, extension)
      new_extension = format_extension || extension.tr('.', '')
    else
      original = model_instance.base_version.filename
      extension = File.extname(original)
      new_filename = file_basename || "#{File.basename(original, extension)}_#{model_instance.version_name}"
      new_extension = format_extension || extension.tr('.', '')
    end
    model_instance.filename = [new_filename, new_extension].join('.')
      
    # TODO: Test
    adapter_instance.attributes.each do |k, v|
      model_instance.send("#{k}=", v) if model_instance.respond_to?(k)
    end 
  end
end