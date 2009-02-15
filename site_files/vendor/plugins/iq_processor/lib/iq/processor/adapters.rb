module IQ::Processor::Adapters # :nodoc:
  autoload :Base,       File.join(File.dirname(__FILE__), 'adapters', 'base')
  autoload :IqImage,    File.join(File.dirname(__FILE__), 'adapters', 'iq_image')
  autoload :Rmagick,    File.join(File.dirname(__FILE__), 'adapters', 'rmagick')
  autoload :MiniMagick, File.join(File.dirname(__FILE__), 'adapters', 'mini_magick')
  
  module Exceptions
    class UnsupportedFileFormatError < StandardError; end
  end
end