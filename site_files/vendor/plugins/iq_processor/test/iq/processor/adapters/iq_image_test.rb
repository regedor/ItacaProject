require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

module IQ::Image
  class Canvas
    extend Mocha::AutoVerify
    
    def self.read(path)
    end
    
    def self.ping(path)
      stub(:format => 'jpg')
    end
    
    def testing
      'test'
    end
    
    def write(path)
    end
  end
end


# self.CONTENT_TYPES
# ------------------
class IQ::Processor::Adapters::IqImage::SelfCONTENTTYPESTest < Test::Unit::TestCase
  def test_should_be_defined
    assert defined?(IQ::Processor::Adapters::IqImage::CONTENT_TYPES), 'Should have constant defined'
  end

  def test_should_return_hash_of_mime_types_for_given_format
    assert_equal(
      {
        'jpg'   => 'image/jpeg',
        'jpeg'  => 'image/jpeg',
        'png'   => 'image/png',
        'gif'   => 'image/gif'
      },
      IQ::Processor::Adapters::IqImage::CONTENT_TYPES
    )
  end
end

# initialize
# ----------
class IQ::Processor::Adapters::IqImage::InitializeTest < Test::Unit::TestCase
  def test_should_raise_when_no_block_given
    assert_raise(ArgumentError) { IQ::Processor::Adapters::IqImage.new('/path/to/file') }
  end
  
  def test_should_raise_when_format_is_not_a_string_or_nil
    assert_raise(ArgumentError) { IQ::Processor::Adapters::IqImage.new('/path/to/file', :not_string) {} }
  end
  
  def test_should_accept_path_to_file_without_format
    assert_nothing_raised { IQ::Processor::Adapters::IqImage.new('/path/to/file') {} }
  end

  def test_should_raise_if_argument_is_not_a_string
    assert_raises(ArgumentError) { IQ::Processor::Adapters::IqImage.new(1) {} }
    assert_raises(ArgumentError) { IQ::Processor::Adapters::IqImage.new(:not_a_string) {} }
  end
  
  def test_should_set_format_instance_variable_to_value_of_format_argument
    instance = IQ::Processor::Adapters::IqImage.new('/path/to/file', 'gif') {}
    assert_equal 'gif', instance.instance_variable_get('@format')
  end
  
  def test_should_set_file_path_instance_variable_to_value_of_file_path_argument
    instance = IQ::Processor::Adapters::IqImage.new('/path/to/file') {}
    assert_equal '/path/to/file', instance.instance_variable_get('@file_path')
  end
  
  def test_should_raise_when_file_format_is_not_supported
    IQ::Image::Canvas.stubs(:ping).with('/path/to/file').returns(stub(:format => 'not_supported'))
    
    assert_raise(IQ::Processor::Adapters::Exceptions::UnsupportedFileFormatError) do
      IQ::Processor::Adapters::IqImage.new('/path/to/file') {}
    end
  end
  
  def test_should_not_raise_when_file_format_is_supported
    IQ::Image::Canvas.stubs(:ping).with('/path/to/file').returns(stub(:format => 'jpg'))
 
    assert_nothing_raised(IQ::Processor::Adapters::Exceptions::UnsupportedFileFormatError) do
      IQ::Processor::Adapters::IqImage.new('/path/to/file') {}
    end
  end
  
  def test_should_read_specified_file_into_iq_image_canvas
    IQ::Image::Canvas.expects(:read).with('/path/to/file')
    IQ::Processor::Adapters::IqImage.new('/path/to/file') {}
  end
end

# write
# -----
class IQ::Processor::Adapters::IqImage::WriteTest < Test::Unit::TestCase
  def test_should_call_write_method_of_iq_image_canvas_with_correct_parameters
    write_expectation = mock()
    write_expectation.expects(:write).with('/path/to/file', {:format => nil})
    IQ::Image::Canvas.stubs(:read).with('/path/to/file').returns(write_expectation)
    instance = IQ::Processor::Adapters::IqImage.new('/path/to/file') { |canvas| canvas }
    instance.write
  end
end

