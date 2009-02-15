require File.join(File.dirname(__FILE__), '..', 'unit_test_helper')

# initialize
# ----------
class IQ::Processor::Adapters::Base::InitializeTest < Test::Unit::TestCase
  def test_should_raise_when_no_block_given
    assert_raise(ArgumentError) { IQ::Processor::Adapters::Base.new('/path/to/file') }
  end
  
  def test_should_raise_when_format_is_not_a_string_or_nil
    assert_raise(ArgumentError) { IQ::Processor::Adapters::Base.new('/path/to/file', :not_string) {} }
  end
  
  def test_should_accept_path_to_file_without_format
    assert_nothing_raised { IQ::Processor::Adapters::Base.new('/path/to/file') {} }
  end

  def test_should_raise_if_argument_is_not_a_string
    assert_raises(ArgumentError) { IQ::Processor::Adapters::Base.new(1) {} }
    assert_raises(ArgumentError) { IQ::Processor::Adapters::Base.new(:not_a_string) {} }
  end
  
  def test_should_set_format_instance_variable_to_value_of_format_argument
    instance = IQ::Processor::Adapters::Base.new('/path/to/file', 'gif') {}
    assert_equal 'gif', instance.instance_variable_get('@format')
  end
  
  def test_should_set_file_path_instance_variable_to_value_of_file_path_argument
    instance = IQ::Processor::Adapters::Base.new('/path/to/file') {}
    assert_equal '/path/to/file', instance.instance_variable_get('@file_path')
  end
end

# write
# -----
class IQ::Processor::Adapters::Base::WriteTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(
      IQ::Processor::Adapters::Base.new('/path/to/file') {},
      :write
    )
  end
end

