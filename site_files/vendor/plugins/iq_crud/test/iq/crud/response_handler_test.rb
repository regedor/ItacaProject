require File.join(File.dirname(__FILE__), 'test_helper')

# initialize
# ----------
class IQ::Crud::ResponseHandler::InitializeTest < Test::Unit::TestCase
  def test_should_set_formats_instance_variable_to_an_empty_array
    assert_equal [], Factory.response_handler_instance.instance_variable_get('@formats')
  end
end

# formats
# -------
class IQ::Crud::ResponseHandler::FormatsTest < Test::Unit::TestCase
  def test_should_response
    assert_respond_to Factory.response_handler_instance, :formats
  end

  def test_should_return_value_of_formats_instance_variable
    instance = Factory.response_handler_instance
    instance.instance_variable_set '@formats', 'the formats'
    assert_equal 'the formats', instance.formats
  end
end

# method_missing
# --------------
class IQ::Crud::ResponseHandler::MethodMissingTest < Test::Unit::TestCase
  def test_should_register_format_in_formats_array_as_array_pair_with_format_first_and_proc_second
    instance = Factory.response_handler_instance
    proc = Proc.new { 'my html response' }
    instance.html &proc
    assert_equal [[:html, proc]], instance.formats
  end

  def test_should_register_format_with_empty_proc_when_no_block_given
    instance = Factory.response_handler_instance
    instance.html
    proc_for_format = instance.formats[0][1]
    assert_instance_of Proc, proc_for_format
    assert_nil proc_for_format.call
  end

  def test_should_raise_when_format_has_already_been_registered
    instance = Factory.response_handler_instance
    instance.html
    assert_raise(ArgumentError) { instance.html }
  end
  
  def test_should_maintain_order_of_formats_array
    instance = Factory.response_handler_instance
    proc_1 = Proc.new { 'my html response' }
    proc_2 = Proc.new { 'my xml response' }
    proc_3 = Proc.new { 'my js response' }
    instance.html &proc_1
    instance.xml  &proc_2
    instance.js   &proc_3
    assert_equal [[:html, proc_1], [:xml, proc_2], [:js, proc_3]], instance.formats
  end
  
  def test_should_allow_nil_to_be_given_as_argument
    assert_nothing_raised() { Factory.response_handler_instance.html nil }
  end
  
  def test_should_raise_if_argument_is_anything_other_than_nil
    assert_raise(ArgumentError) { Factory.response_handler_instance.html 'not nil' }
  end
  
  def test_should_raise_when_too_many_arguments_supplied
    assert_raise(ArgumentError) { Factory.response_handler_instance.html nil, 'another argument' }
  end
  
  def test_should_raise_when_argument_and_block_given
    assert_raise(ArgumentError) { Factory.response_handler_instance.html(nil) {} }
  end
  
  def test_should_store_proc_as_nil_when_nil_argument_given
    instance = Factory.response_handler_instance
    instance.html nil
    assert_equal [[:html, nil]], instance.formats
  end
end