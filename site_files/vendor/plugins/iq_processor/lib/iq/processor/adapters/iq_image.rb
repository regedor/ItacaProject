class IQ::Processor::Adapters::IqImage < IQ::Processor::Adapters::Base
  CONTENT_TYPES = {
    'jpg'   => 'image/jpeg',
    'jpeg'  => 'image/jpeg',
    'png'   => 'image/png',
    'gif'   => 'image/gif'
  }

  # TODO: Test this
  def initialize(model_instance, file_path, format = nil, &block)
    unless CONTENT_TYPES.keys.include?(IQ::Image::Canvas.ping(file_path).format)
      raise IQ::Processor::Adapters::Exceptions::UnsupportedFileFormatError, "Don't know how to handle '#{file_path}'"
    end
    
    super

    self.canvas = base_version.instance_exec(IQ::Image::Canvas.read(file_path), &block)
  end
  
  # TODO: Test this
  def attributes
    raise 'You can only access this adapters attributes after write has been called' unless written?
    
    super.merge({
      :width        => canvas.width,
      :height       => canvas.height,
      :content_type => CONTENT_TYPES[canvas.format.downcase],
      :file_size    => File.size(file_path)
    })
  end
  
  # TODO: Test this
  def write
    canvas.write(file_path, :format => format)
    self.written = true
  end
  
  private
  
  attr_accessor :canvas
  attr_writer   :written
  
  def written?
    !!@written
  end
end