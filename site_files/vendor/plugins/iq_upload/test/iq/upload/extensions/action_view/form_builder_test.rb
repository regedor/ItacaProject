require File.join(File.dirname(__FILE__), '..', '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Definition
# -----------------------------------------------------------------------------------------------
class IQ::Upload::Extensions::ActionView::FormBuilder::ClassDefinitionTest < Test::Unit::TestCase
  def test_should_be_included_into_action_view
    assert(
      ActionView::Helpers::FormBuilder.included_modules.include?(IQ::Upload::Extensions::ActionView::FormBuilder),
      'FormBuilder should be included into ActionView::Helpers::FormBuilder'
    )
  end
end

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# uploadify_file_field
# --------------------
class IQ::Upload::Extensions::ActionView::FormBuilder::UploadFileFieldTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.form_builder_instance, :uploadify_file_field
  end

  def test_should_dispatch_to_template_instance_variable
    instance = Factory.form_builder_instance
    template = mock('Mocked Template')
    template.stubs(:uploadify_file_field).with('my-object-name', nil, :object => 'my-object').returns('the-result')
    instance.instance_variable_set '@template',     template
    instance.instance_variable_set '@object_name',  'my-object-name'
    instance.instance_variable_set '@object',       'my-object'
    assert_equal 'the-result', instance.uploadify_file_field
  end
  
  def test_should_accept_alternate_method_argument
    instance = Factory.form_builder_instance
    template = mock('Mocked Template')
    template.stubs(:uploadify_file_field).with(
      'my-object-name', :my_method, :object => 'my-object'
    ).returns('the-result')
    instance.instance_variable_set '@template',     template
    instance.instance_variable_set '@object_name',  'my-object-name'
    instance.instance_variable_set '@object',       'my-object'
    assert_equal 'the-result', instance.uploadify_file_field(:my_method)
  end

  def test_should_pass_though_options_hash_with_object_instance_variable_merged_in_as_object_option
    instance = Factory.form_builder_instance
    template = mock('Mocked Template')
    template.stubs(:uploadify_file_field).with(
      'my-object-name', nil, :object => 'my-object', :my_option => 'my-option'
    ).returns('the-result')
    instance.instance_variable_set '@template',     template
    instance.instance_variable_set '@object_name',  'my-object-name'
    instance.instance_variable_set '@object',       'my-object'
    assert_equal 'the-result', instance.uploadify_file_field(:my_option => 'my-option', :object => 'should-be-ignored')
  end
end

