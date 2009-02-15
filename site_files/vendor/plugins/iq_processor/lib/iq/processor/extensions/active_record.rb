module IQ::Processor::Extensions::ActiveRecord # :nodoc:
  def process(*args, &block)
    options = args.extract_options!
    
    suffix = args.first
    
    unless suffix.nil? || suffix.is_a?(Symbol) || suffix.is_a?(String)
      raise ArgumentError, 'Suffix must be a Symbol or String'
    end
#    raise ArgumentError, 'Adapter must be a Symbol' if options.key?(:adapter) && !options[:adapter].is_a?(Symbol)
    raise ArgumentError, 'Block must be supplied' unless block_given?
    
    unless included_modules.include? IQ::Processor::Base
      @version_handlers = {}
      @base_version_handler = nil
      class << self
        attr_reader :version_handlers
        attr_reader :base_version_handler
      end

      include IQ::Processor::Base
    end

#    adapter_name = options[:adapter] || IQ::Processor::Config.default_adapter
#    adapter_class = IQ::Processor::Config.adapters[adapter_name]
#    raise ArgumentError, ':adapter option must be a registered adapter' if adapter_class.nil?
#    self.adapter = adapter_class.new(self)
    if suffix.nil?
      @base_version_handler = IQ::Processor::VersionHandler.new(options, &block)
    else
      @version_handlers[suffix.to_s] = IQ::Processor::VersionHandler.new(options, &block)
    end
  end
end