module IQ::Processor::Adapters
  # Base class for Processor Processors.
  # Processors are used to create conversions (thumbnails etc) of uploaded images.
  class Base
#    include IQ::Processor::FileHelpers
#    attr_accessor :asset_class
#
#    # Passed the <tt>asset_class</tt> it will work against.
    def initialize(model_instance, file_path, format = nil, &block)
      raise ArgumentError, 'Path to file must be supplied as a String' unless file_path.is_a?(String)
      raise ArgumentError, 'format must be supplied as a String' unless format.nil? || format.is_a?(String)
      raise ArgumentError, 'A block must be supplied' unless block_given?
      self.format = format
      self.file_path = file_path
      base_version_instance = model_instance.base_version? ? model_instance : model_instance.base_version
      base_version_instance = base_version_instance.target if base_version_instance.respond_to?(:target)
      self.base_version = base_version_instance
    end
    
    def write

    end
    
    # TODO: Test
    def attributes
      {}
    end
    
    private
    
    attr_accessor :file_path, :format, :base_version
  end
end
