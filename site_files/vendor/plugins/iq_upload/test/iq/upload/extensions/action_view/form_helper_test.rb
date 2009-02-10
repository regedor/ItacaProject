require File.join(File.dirname(__FILE__), '..', '..', 'unit_test_helper')

# -----------------------------------------------------------------------------------------------
# Class Definition
# -----------------------------------------------------------------------------------------------
class IQ::Upload::Extensions::ActionView::FormHelper::ClassDefinitionTest < Test::Unit::TestCase
  def test_should_be_included_into_action_view
    assert(
      ActionView::Base.included_modules.include?(IQ::Upload::Extensions::ActionView::FormHelper),
      'FormHelper should be included into ActionView::Base'
    )
  end
end

# -----------------------------------------------------------------------------------------------
# Instance Methods
# -----------------------------------------------------------------------------------------------

# uploadify_file_field
# --------------------
class IQ::Upload::Extensions::ActionView::FormHelper::UploadFileFieldTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.form_helper_instance, :uploadify_file_field
  end

  def test_should_accept_object_name_string_as_first_argument
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('my_object') }
  end
  
  def test_should_raise_when_first_argument_is_not_a_string_or_a_symbol
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_raise(ArgumentError) { instance.uploadify_file_field(123) }
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field(:ok_object_name) }
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('ok_object_name') }
  end
  
  def test_should_optionally_accept_method_argument
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('my_object', 'my_data_method') }
  end
  
  def test_should_raise_when_method_argument_is_not_a_string_or_symbol
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_raise(ArgumentError) { instance.uploadify_file_field('my_object', 123) }
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('my_object', :ok_method_name) }
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('my_object', 'ok_method_name') }
  end
  
  def test_should_should_accept_options_hash
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_nothing_raised(ArgumentError) { instance.uploadify_file_field('my_object', {}) }
  end
  
  def test_should_raise_when_options_argument_is_not_a_hash
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_raise(ArgumentError) { instance.uploadify_file_field('my_object', 'my_method', :not_a_hash) }
  end

  def test_should_accept_object_option
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_nothing_raised(ArgumentError) do
      instance.uploadify_file_field('my_object', :object => stub(:filename => 'the-filename'))
    end
  end

  def test_should_accept_tempfile_method_option
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    assert_nothing_raised(ArgumentError) do
      instance.uploadify_file_field('my_object', :tempfile_method => 'my_temp_path_method')
    end
  end
  
  def test_should_raise_when_tempfile_method_is_not_a_string
    assert_raise(ArgumentError) do
      Factory.form_helper_instance.uploadify_file_field('my_object', :tempfile_method => :not_a_string)
    end
  end

  def test_should_raise_for_invalid_options
    assert_raise(ArgumentError) do
      Factory.form_helper_instance.uploadify_file_field('my_object', :nonsense => 'option')
    end
  end

  def test_should_include_hidden_field_result_in_output
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).with('my_object', 'already_uploaded_data', :object => nil).returns('the-hidden-field')
    assert_match /the-hidden-field/, instance.uploadify_file_field('my_object')
  end

  def test_should_call_hidden_field_with_correct_options_when_given_method_argument
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).with('my_object', 'already_uploaded_data', :object => nil).returns('the-hidden-field')
    assert_match /the-hidden-field/, instance.uploadify_file_field('my_object', 'my_data')
  end

  def test_should_call_hidden_file_field_with_correct_options_when_given_tempfile_method_option
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).with('my_object', 'my_method', :object => nil).returns('the-hidden-field')
    assert_match /the-hidden-field/, instance.uploadify_file_field('my_object', :tempfile_method => 'my_method')
  end

  def test_should_call_hidden_field_with_correct_options_when_given_object_option
    instance = Factory.form_helper_instance
    object = stub(:filename => 'the-filename')
    instance.stubs(:hidden_field).with(
      'my_object', 'already_uploaded_data', :object => object
    ).returns('the-hidden-field')
    assert_match /the-hidden-field/, instance.uploadify_file_field('my_object', :object => object)
  end

  def test_should_output_file_field_using_instance_tag
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    instance_tag = mock('Mocked InstanceTag')
    instance_tag.stubs(:to_input_field_tag).with('file', { :object => nil }).returns('the-file-field')
    ActionView::Helpers::InstanceTag.stubs(:new).with(
      'my_object', "uploaded_data", instance, nil, nil
    ).returns(instance_tag)
    assert_match /the-file-field/, instance.uploadify_file_field('my_object')
  end
  
  def test_should_output_file_field_using_instance_tag_that_takes_into_account_method_argument
    instance = Factory.form_helper_instance
    instance.stubs(:hidden_field).returns('the-hidden-field')
    instance_tag = mock('Mocked InstanceTag')
    instance_tag.stubs(:to_input_field_tag).with('file', { :object => nil }).returns('the-file-field')
    ActionView::Helpers::InstanceTag.stubs(:new).with(
      'my_object', "my_method", instance, nil, nil
    ).returns(instance_tag)
    assert_match /the-file-field/, instance.uploadify_file_field('my_object', 'my_method')
  end

  def test_should_output_file_field_using_instance_tag_that_takes_into_account_object_option
    instance = Factory.form_helper_instance
    object = stub(:filename => 'the-filename')
    instance.stubs(:hidden_field).returns('the-hidden-field')
    instance_tag = mock('Mocked InstanceTag')
    instance_tag.stubs(:to_input_field_tag).with('file', { :object => object }).returns('the-file-field')
    ActionView::Helpers::InstanceTag.stubs(:new).with(
      'my_object', "uploaded_data", instance, nil, object
    ).returns(instance_tag)
    assert_match /the-file-field/, instance.uploadify_file_field('my_object', :object => object)
  end

  def test_should_output_span_containing_filename_when_object_given
    instance = Factory.form_helper_instance
    object = stub(:filename => 'the-filename')
    instance.stubs(:hidden_field).with(
      'my_object', 'already_uploaded_data', :object => object
    ).returns('the-hidden-field')
    assert_match(
      /<span class=\"my-object-uploaded-file\">the-filename<\/span>/, 
      instance.uploadify_file_field('my_object', :object => object)
    )
  end
  
  def test_should_output_empty_span_when_no_object_given
    instance = Factory.form_helper_instance
    object = stub(:filename => 'the-filename')
    instance.stubs(:hidden_field).with('my_object', 'already_uploaded_data', :object => nil).returns('the-hidden-field')
    assert_match /<span class=\"my-object-uploaded-file\"><\/span>/, instance.uploadify_file_field('my_object')
  end
  
  def test_should_use_inteligent_defaults_for_prefixes_to_uploaded_data
    instance = Factory.form_helper_instance
    object = stub(:an_image_filename => 'the-filename')
    instance.stubs(:hidden_field).with(
      'my_object', 'an_image_already_uploaded_data', :object => object
    ).returns('the-hidden-field')
    instance_tag = mock('Mocked InstanceTag')
    instance_tag.stubs(:to_input_field_tag).with('file', { :object => object }).returns('the-file-field')
    ActionView::Helpers::InstanceTag.stubs(:new).with(
      'my_object', :an_image_uploaded_data, instance, nil, object
    ).returns(instance_tag)
    assert_equal(
      '<span class="my-object-an-image-uploaded-file">the-filename</span> the-hidden-fieldthe-file-field',
      instance.uploadify_file_field('my_object', :an_image_uploaded_data, :object => object)
    )
  end
end