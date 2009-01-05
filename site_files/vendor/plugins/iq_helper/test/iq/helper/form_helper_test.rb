require File.join(File.dirname(__FILE__), 'test_helper')
require 'action_controller/record_identifier'
require 'action_controller/polymorphic_routes'

# test_helper
# -----------
class Test::Unit::TestCase
  attr_reader :form_helper
  
  def setup
    @form_helper = FormHelperTester.new
  end
  
  private

end

# label
# -----
class IQ::Helper::FormHelper::LabelTest < Test::Unit::TestCase
  def test_should_exist
    assert_respond_to(view_instance, :label)
  end
  
  def test_should_ouput_label_tag_with_humanized_name
    assert_dom_equal('<label for="post_title">Title</label>', form_helper.label('post', 'title'))
    assert_dom_equal('<label for="post_two_words">Two words</label>', form_helper.label('post', 'two_words'))
  end
  
  def test_should_accept_options
    assert_dom_equal(
      '<label for="post_title" class="pretty">Title</label>', form_helper.label('post', 'title', :class => 'pretty')
    )
  end
  
  def test_should_accept_text_option
    assert_dom_equal(
      '<label for="post_title">Custom</label>', form_helper.label('post', 'title', :text => 'Custom')
    )
  end
end

# button
# ------
class IQ::Helper::FormHelper::LabelTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to view_instance, :button
  end
  
  def test_should_ouput_button_tag_with_humanized_name_by_default
    assert_dom_equal(
      '<button id="post_my_method" name="post[my_method]">My method</button>', 
      form_helper.button('post', 'my_method')
    )
  end
  
  def test_should_accept_and_use_options
    assert_dom_equal(
      '<button id="post_title" name="post[title]" class="pretty">Title</button>',
      form_helper.button('post', 'title', :class => 'pretty')
    )
  end
  
  def test_should_accept_and_use_text_option
    assert_dom_equal(
      '<button id="post_title" name="post[title]">Custom</button>',
      form_helper.button('post', 'title', :text => 'Custom')
    )
  end
  
  def test_should_allow_override_of_id_and_name
    assert_dom_equal(
      '<button id="my_id" name="foo[bar]">Title</button>',
      form_helper.button('post', 'title', :name => 'foo[bar]', :id => 'my_id')
    )
  end
end

# label_tag
# ---------
class IQ::Helper::FormHelper::LabelTagTest < Test::Unit::TestCase
  def test_label_tag
    assert_dom_equal('<label for="title">A label</label>', form_helper.label_tag('title', 'A label'))
  end

  def test_label_tag_with_class
    assert_dom_equal(
      '<label for="title" class="pretty">A label</label>', form_helper.label_tag('title', 'A label', :class => 'pretty')
    )
  end
end

# form_for
# --------
class IQ::Helper::FormHelper::FormForTest < Test::Unit::TestCase
  def test_form_for_should_use_namespaces
    _erbout = ''
    @form_helper.stubs(:admin_test_records_path).returns('/admin/test_records')
    @form_helper.stubs(:controller).returns(stub(:controller_path => 'admin/test_records'))
    @form_helper.stubs(:allow_forgery_protection)
    assert_dom_equal(
      '<form class="new_test_record" action="/admin/test_records" method="post" id="test_record_1"></form>',
      form_helper.form_for(stub(:id => 1, :class => stub(:name => 'TestRecord'), :new_record? => true)) do
      end
    )
  end
  
  def test_form_for_should_use_namespaces_when_string_and_object_given
    assert_uses_namespaces_with_name_and_object_given('moose')
  end
  
  def test_form_for_should_use_namespaces_when_symbol_and_object_given
    assert_uses_namespaces_with_name_and_object_given(:moose)
  end
  
  private
  
  def assert_uses_namespaces_with_name_and_object_given(name)
    _erbout = ''
    @form_helper.stubs(:admin_test_records_path).returns('/admin/test_records')
    @form_helper.stubs(:controller).returns(stub(:controller_path => 'admin/test_records'))
    @form_helper.stubs(:allow_forgery_protection)
    assert_dom_equal(
      '<form class="new_test_record" action="/admin/test_records" method="post" id="test_record_1"><input name="'+name.to_s+'[name]" size="22" type="text" id="'+name.to_s+'_name" value="test record" maxlength="20" /></form>',
      form_helper.form_for(name, stub(:id => 1, :class => stub(:name => 'TestRecord'), :column_for_attribute => stub(:name => 'name', :limit => 20), :new_record? => true, :name => 'test record', :test_record => 'test record')) do |f|
        _erbout += f.text_field :name
      end
    )
  end
end