require File.join(File.dirname(__FILE__), 'test_helper')

# Need Presenter for some tests
module IQ::Presenter
  class Column
  end
end

# test_helper
# -----------
class Test::Unit::TestCase
  
  private
  
  DEFAULT_HTML_OPTIONS = {
    :text_area      => { :rows => 10 },
    :text_field     => { :size => 30 },
    :password_field => { :size => 30 }
  }
  
  def defaults_for(method = nil)
    DEFAULT_HTML_OPTIONS[(method || helper_method_name).to_sym] || {}
  end
  
  def assert_helper_called_correctly(
    column_stub_options, supplied_options, expected, method = helper_method_name, additional_args = []
  )
    object = mock()
    object.stubs(:column_for_attribute).with(:the_column).returns(
      column_stub_options.empty? ? nil : stub_everything(column_stub_options)
    )
    object.stubs(:the_column => 1234)

    assert_dom_equal(
      view_instance.send(
        method, 'an_instance', :the_column,
        defaults_for(method).merge(expected).merge(:object => object), *additional_args
      ),
      builder_instance('an_instance', object).send(helper_method_name, :the_column, supplied_options)
    )
  end
  
  def assert_builder_method_only_accepts_column_or_method_and_options_hash(sym)
    builder = builder_instance('an_instance', stub(:column_for_attribute => stub_everything()), stub_everything())
    assert_raise(ArgumentError) { builder.send(sym, mock('Not a sym, string or column')) }
    assert_raise(ArgumentError) { builder.send(sym, :summary, :not_a_hash) }
    assert_nothing_raised { builder.send(sym, :summary) }
    assert_nothing_raised { builder.send(sym, 'summary', :class => 'pretty') }
    assert_nothing_raised do
      builder.send(sym, stub_everything(:kind_of? => [ActiveRecord::ConnectionAdapters::Column]))
    end
    assert_nothing_raised { builder.send(sym, stub_everything(:name => 'something')) }
  end
  
  def helper_method_name
    self.class.name.demodulize.chomp('Test').underscore.to_sym
  end
  
  def builder_instance(
    object_name = 'an_instance', object = mock(), template = view_instance, options = {}, proc = Proc.new {}
  )
    IQ::Helper::FormBuilder.new(object_name, object, template, options, proc)
  end
end

# FormBuilder
# -----------
class IQ::Helper::FormBuilderTest < Test::Unit::TestCase  
  def test_should_use_custom_form_builder_by_default
    assert_equal IQ::Helper::FormBuilder, ActionView::Base.default_form_builder
  end

  def test_should_inherit_standard_form_builder
    assert_equal ActionView::Helpers::FormBuilder, IQ::Helper::FormBuilder.superclass
  end
end
  
# text_field
# ----------
class IQ::Helper::FormBuilder::TextFieldTest < Test::Unit::TestCase
  def test_should_use_default_behaviour_when_there_is_no_object
    template = mock(helper_method_name => ['an_instance', :the_column, { :object => nil }])
    builder_instance('an_instance', nil, template).send(helper_method_name, :the_column)
  end
  
  def test_should_use_default_behaviour_when_column_cannot_be_determined
#    assert_helper_called_correctly({}, {}, {})
  end
  
  def test_should_set_size_and_maxlength_from_column_limit
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with(
      'an_instance', 'a_column', 'size' => 16, 'maxlength' => 14, :object => object
    )
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(stub_everything(:name => 'a_column', :type => :string, :limit => 14))
  end
  
  def test_should_cap_auto_size_at_default_size
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with(
      'an_instance', 'a_column', 'size' => 30, 'maxlength' => 55, :object => object
    )
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(stub_everything(:name => 'a_column', :type => :string, :limit => 55))
  end
  
  def test_should_set_size_to_30_and_not_set_maxlength_if_limit_is_nil
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with('an_instance', 'a_column', 'size' => 30, :object => object)
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(stub_everything(:name => 'a_column', :type => :string))
  end
    
  def test_should_set_maxlength_from_option_if_supplied
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with(
      'an_instance', 'a_column', 'size' => 16, 'maxlength' => 10, :object => object
    )
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(stub_everything(:name => 'a_column', :type => :string, :limit => 14), :maxlength => 10)
  end
  
  def test_should_set_size_from_option_if_supplied
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with(
      'an_instance', 'a_column', 'size' => 10, 'maxlength' => 14, :object => object
    )
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(stub_everything(:name => 'a_column', :type => :string, :limit => 14), :size => 10)
  end
  
  def test_should_merge_column_options_if_they_exist
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:text_field).with(
      'an_instance', 'a_column', 'size' => 16, 'maxlength' => 14, :object => object, 'class' => 'foo'
    )
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.text_field(
      stub_everything(:name => 'a_column', :type => :string, :limit => 14, :options => { :class => 'foo' })
    )
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.text_field stub_everything(:name => 'a_column')
  end
  
  def test_should_not_attempt_to_call_method_on_object_when_postback_option_supplied
    object = stub_everything('a fake object')
    object.expects(:a_column).never
    instance = Factory.form_builder(:object => object)
    instance.text_field(stub_everything(:name => 'commit'), :postback => :save)
  end
  
  def test_should_put_tag_in_postback_namespace_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_equal(
      "<input id=\"new_foo_save_commit\" name=\"an_instance[_save][commit]\" size=\"30\" type=\"text\" value=\"\" />",
      instance.text_field(stub_everything(:name => 'commit'), :postback => :save)
    )
  end
  
  def test_should_use_record_identification_for_id_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:id => 10, :class => stub(:name => 'Foo')))
    assert_equal(
      "<input id=\"foo_10_save_commit\" name=\"an_instance[_save][commit]\" size=\"30\" type=\"text\" value=\"\" />",
      instance.text_field(stub_everything(:name => 'commit'), :postback => :save)
    )
  end
end

# password_field
# --------------
class IQ::Helper::FormBuilder::PasswordFieldTest < IQ::Helper::FormBuilder::TextFieldTest
  # This has it's tests defined by inheriting TextFieldTest
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.password_field stub_everything(:name => 'a_column')
  end
  
  def test_should_not_attempt_to_call_method_on_object_when_postback_option_supplied
    object = stub_everything('a fake object')
    object.expects(:a_column).never
    instance = Factory.form_builder(:object => object)
    instance.password_field(stub_everything(:name => 'commit'), :postback => :save)
  end
  
  def test_should_put_tag_in_postback_namespace_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_equal(
      "<input id=\"new_foo_save_commit\" name=\"an_instance[_save][commit]\" size=\"30\" type=\"password\" value=\"\" />",
      instance.password_field(stub_everything(:name => 'commit'), :postback => :save)
    )
  end
  
  def test_should_use_record_identification_for_id_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:id => 10, :class => stub(:name => 'Foo')))
    assert_equal(
      "<input id=\"foo_10_save_commit\" name=\"an_instance[_save][commit]\" size=\"30\" type=\"password\" value=\"\" />",
      instance.password_field(stub_everything(:name => 'commit'), :postback => :save)
    )
  end
end

# text_area
# ---------
class IQ::Helper::FormBuilder::TextAreaTest < Test::Unit::TestCase
  def test_should_use_defaults
    assert_helper_called_correctly({}, {}, defaults_for)
  end
  
  def test_should_set_rows_from_option_if_supplied
    assert_helper_called_correctly({}, { :rows => 22 }, { :rows => 22 })
  end
  
  def test_should_merge_column_options_if_they_exist
    assert_dom_equal(
      "<textarea name=\"an_instance[my_name]\" class=\"foo\" id=\"an_instance_my_name\" cols=\"40\" rows=\"10\">" +
      "</textarea>",
      Factory.form_builder(:object => stub_everything).text_area(
        stub_everything(:name => 'my_name', :options => { :class => 'foo' })
      )
    )    
  end
  
  def test_should_merge_column_options_if_they_exist_over_supplied_options
    assert_dom_equal(
      "<textarea name=\"an_instance[my_name]\" class=\"bar\" id=\"an_instance_my_name\" cols=\"40\" rows=\"10\">" +
      "</textarea>",
      Factory.form_builder(:object => stub_everything).text_area(
        stub_everything(:name => 'my_name', :options => { :class => 'foo' }), :class => 'bar'
      )
    )    
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.text_area stub_everything(:name => 'a_column')
  end
end

# hidden_field
# ------------
class IQ::Helper::FormBuilder::HiddenFieldTest < Test::Unit::TestCase
  def test_should_use_defaults
    assert_helper_called_correctly({}, {}, defaults_for)
  end
  
  def test_should_merge_column_options_if_they_exist
    assert_helper_called_correctly(
      { :options => { :class => 'custom' } }, {}, { :class => 'custom' }
    )
  end
  
  def test_should_merge_column_options_if_they_exist_over_supplied_options
    assert_dom_equal(
      "<input name=\"an_instance[my_name]\" class=\"bar\" type=\"hidden\"" +
      " id=\"an_instance_my_name\"/>",
      Factory.form_builder(:object => stub_everything).hidden_field(
        stub_everything(:name => 'my_name', :options => { :class => 'foo' }), :class => 'bar'
      )
    )
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.hidden_field stub_everything(:name => 'a_column')
  end
end

# file_field
# ----------
class IQ::Helper::FormBuilder::HiddenFieldTest < Test::Unit::TestCase
  def test_should_use_defaults
    assert_helper_called_correctly({}, {}, {})
  end
  
  def test_should_merge_column_options_if_they_exist
    assert_helper_called_correctly(
      { :options => { :class => 'custom' } }, {}, { :class => 'custom' }
    )
  end
  
  def test_should_use_supplied_options_over_column_options_if_they_exist
    assert_dom_equal(
      "<input name=\"an_instance[my_name]\" class=\"bar\" type=\"file\"" +
      " id=\"an_instance_my_name\" size=\"30\"/>",
      Factory.form_builder.file_field(
        stub_everything(:name => 'my_name', :options => { :class => 'foo' }), :class => 'bar'
      )
    )
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.file_field stub_everything(:name => 'a_column')
  end
end

# field
# -----
class IQ::Helper::FormBuilder::FieldTest < Test::Unit::TestCase
  def test_should_exist
    assert_respond_to(builder_instance, :field)
  end
  
  def test_should_when_argument_not_a_string_or_symbol_or_column
    object = stub_everything()
    instance = Factory.form_builder(:object => object)
    assert_raise(ArgumentError) { instance.field 321 }
  end
  
  def test_should_raise_when_column_cannot_be_found
    builder = builder_instance('an_instance', stub(:column_for_attribute => nil))
    assert_raise(ArgumentError) { builder.field(:summary) }
  end
  
  def test_should_use_column_helper_option_if_available
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:custom).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :datetime, :helper => :custom))
  end
  
  def test_should_call_text_field_by_default
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:text_field).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :not_a_real_type))
  end
  
  def test_should_call_text_area_for_column_type_of_text
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:text_area).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :text))
  end
  
  def test_should_call_check_box_for_column_type_of_boolean
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:check_box).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :boolean))
  end
  
  def test_should_call_date_select_for_column_type_of_date
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:date_select).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :date))
  end
  
  def test_should_call_datetime_select_for_column_type_of_datetime
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:datetime_select).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :datetime))
  end
  
  def test_should_call_datetime_select_for_column_type_of_timestamp
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:datetime_select).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :timestamp))
  end
  
  def test_should_call_time_select_for_column_type_of_time
    instance = Factory.form_builder(:object => mock('Fake object'))
    instance.stubs(:time_select).returns('foo')
    assert_equal 'foo', instance.field(stub_everything(:name => 'a_column', :type => :time))
  end

  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.field stub_everything(:name => 'a_column')
  end
  
  def test_should_evaluate_value_option_on_object_when_proc
    object = stub_everything()
    object.stubs(:test_method).returns('TEST!')
    view_instance = Factory.view_instance
    view_instance.stubs(:text_field).with('an_instance', 'a_column', {
      'size' => 30, :object => object, 'value' => 'TEST!'
    }).returns('properly called text_field')
    instance = Factory.form_builder(:object => object, :template => view_instance)
    assert_equal 'properly called text_field', instance.field(stub_everything(:name => 'a_column', :options => { 
      :value => Proc.new { |object| object.test_method } 
    }))
  end
end

# button
# ------
class IQ::Helper::FormBuilder::ButtonTest < Test::Unit::TestCase
  def test_should_merge_column_options_if_they_exist
    object = mock('Fake object')
    view_instance = Factory.view_instance
    view_instance.expects(:button).with('an_instance', 'a_column', :object => object, 'value' => nil)
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.button(stub_everything(:name => 'a_column', :type => :string))
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.button stub_everything(:name => 'a_column')
  end
  
  def test_should_not_attempt_to_call_method_on_object_when_postback_option_supplied
    object = stub_everything('a fake object')
    object.expects(:a_column).never
    instance = Factory.form_builder(:object => object)
    instance.button(stub_everything(:name => 'commit'), :postback => :save)
  end
  
  def test_should_use_default_as_per_template_helper
    assert_dom_equal(
      "<button id=\"an_instance_my_name\" name=\"an_instance[my_name]\">My name</button>",
      Factory.form_builder.button(stub_everything(:name => 'my_name'))
    )   
  end
  
  def test_should_use_value_option_as_override_for_default_value
    assert_dom_equal(
      "<button id=\"an_instance_my_name\" name=\"an_instance[my_name]\" value=\"my value\">My name</button>",
      Factory.form_builder.button(stub_everything(:name => 'my_name'), :value => 'my value')
    )   
  end
  
  def test_should_put_tag_in_postback_namespace_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_dom_equal(
      "<button id=\"new_foo_save_my_name\" name=\"an_instance[_save][my_name]\">My name</button>",
      instance.button(stub_everything(:name => 'my_name'), :postback => :save)
    )
  end
  
  def test_should_use_record_identification_for_id_when_postback_option_supplied
    instance = Factory.form_builder(:object => stub_everything(:id => 10, :class => stub(:name => 'Foo')))
    assert_equal(
      "<button id=\"foo_10_save_my_name\" name=\"an_instance[_save][my_name]\">My name</button>",
      instance.button(stub_everything(:name => 'my_name'), :postback => :save)
    )
  end
  
  def test_should_set_contents_of_button_to_humanized_postback_name_when_name_is_commit_and_postback_supplied
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_dom_equal(
      "<button id=\"new_foo_save_thingy_commit\" name=\"an_instance[_save_thingy][commit]\">Save thingy</button>",
      instance.button(stub_everything(:name => 'commit'), :postback => :save_thingy)
    )
  end

  def test_should_set_contents_of_button_to_humanized_postback_name_when_name_is_commit_and_column_with_postback_given
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_dom_equal(
      "<button id=\"new_foo_save_thingy_commit\" name=\"an_instance[_save_thingy][commit]\">Save thingy</button>",
      instance.button(stub_everything(:name => 'commit', :options => { :postback => :save_thingy }))
    )
  end
  
  def test_should_set_contents_of_button_to_supplied_when_name_is_commit_and_postback_present
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_dom_equal(
      "<button id=\"new_foo_save_thingy_commit\" name=\"an_instance[_save_thingy][commit]\">Fooey</button>",
      instance.button(stub_everything(:name => 'commit'), :postback => :save_thingy, :text => 'Fooey')
    )
  end
  
  def test_should_set_contents_of_button_to_column_text_option_when_name_is_commit_and_postback_present
    instance = Factory.form_builder(:object => stub_everything(:class => stub(:name => 'Foo')))
    assert_dom_equal(
      "<button id=\"new_foo_save_thingy_commit\" name=\"an_instance[_save_thingy][commit]\">Fooey</button>",
      instance.button(stub_everything(:name => 'commit', :options => { :text => 'Fooey' }), :postback => :save_thingy)
    )
  end
  
  def test_should_determine_column_for_button_name_and_postback
    object = stub_everything(:class => stub(:name => 'Foo'))
    object.expects(:column_for_attribute).with(:commit, :save).returns(
      stub_everything(:name => 'commit', :postback => 'save', :options => { :class => 'foo', :text => 'SAVE!!!' })
    )
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<button id=\"new_foo_save_commit\" name=\"an_instance[_save][commit]\" class=\"foo\">SAVE!!!</button>",
      instance.button(:commit, :postback => :save)
    )
  end
  
  def test_should_use_postbacks_with_multiple_namespaces_correctly
    object = stub_everything(:class => stub(:name => 'Foo'))
    object.expects(:column_for_attribute).with(:commit, 'castings/add').returns(
      stub_everything(:name => 'commit', :postback => 'castings/add', :options => { :text => 'Add New Casting' })
    )
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<button id=\"new_foo_castings_add_commit\" name=\"an_instance[castings][_add][commit]\">Add New Casting</button>",
      instance.button(:commit, :postback => 'castings/add')
    )
  end
  
  def test_should_determine_name_from_postbacks_with_multiple_namespaces_correctly
    object = stub_everything(:class => stub(:name => 'Foo'))
    object.expects(:column_for_attribute).with(:commit, 'castings/add').returns(
      stub_everything(:name => 'commit', :postback => 'castings/add')
    )
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<button id=\"new_foo_castings_add_commit\" name=\"an_instance[castings][_add][commit]\">Add castings</button>",
      instance.button(:commit, :postback => 'castings/add')
    )
  end
end



# label
# -----
class IQ::Helper::FormBuilder::LabelTest < Test::Unit::TestCase
  def test_should_exist
    assert_respond_to(builder_instance, :label)
  end
  
  def test_should_raise_for_invalid_arguments
    assert_builder_method_only_accepts_column_or_method_and_options_hash(:label)
  end
  
  def test_should_use_default_behaviour_when_column_cannot_be_determined
    assert_helper_called_correctly({}, {}, {})
  end
  
  def test_should_allow_text_option_when_column_unavailable
    assert_helper_called_correctly({}, { :text => 'Custom' }, { :text => 'Custom' })
  end
  
  def test_should_use_column_label_method_over_human_name_or_supplied
    assert_helper_called_correctly(
      { :name => :the_column, :human_name => 'My name', :label => 'Custom name' },
      { :text => 'Supplied name' },
      { :text => 'Custom name' }
    )
  end
  
  def test_should_use_text_option_over_human_name_if_supplied
    assert_helper_called_correctly(
      { :name => :the_column, :human_name => 'My name' }, 
      { :text => 'Supplied name' },
      { :text => 'Supplied name' })
  end
  
  def test_should_use_column_human_name_if_column_found_and_column_label_option_not_available
    assert_helper_called_correctly(
      { :name => :the_column, :human_name => 'My name' },
      {},
      { :text => 'My name' }
    )
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.label stub_everything(:name => 'a_column')
  end
end

# render
# ------
class IQ::Helper::FormBuilder::RenderTest < Test::Unit::TestCase
  def test_should_exist
    assert_respond_to(builder_instance, :render)
  end
  
  def test_should_raise_for_invalid_arguments
    sym = :render
    builder = builder_instance('an_instance', stub(:column_for_attribute => stub_everything()), stub_everything())
    assert_raise(ArgumentError) { builder.send(sym, mock('Not a sym, string or column')) }
    assert_raise(ArgumentError) { builder.send(sym, :summary, :not_a_hash) }
    assert_nothing_raised { builder.send(sym, :summary) }
    assert_raise(ArgumentError) { builder.send(sym, 'summary', :class => 'pretty') }
    assert_nothing_raised do
      builder.send(sym, stub_everything(:kind_of? => [ActiveRecord::ConnectionAdapters::Column]))
    end
    assert_nothing_raised { builder.send(sym, stub_everything(:name => 'something')) }
  end
  
  def test_should_render_partial_defined_in_column_and_no_widget
    assert_render_for_column('my_custom_partial', :partial => 'my_custom_partial', :widget => nil)
  end
  
  def test_should_render_default_partial_if_not_defined_in_column_and_no_widget
    assert_render_for_column('widgets/simple', :partial => nil, :widget => nil)
  end
  
  def test_should_render_partial_based_in_widget_if_widget_set_and_no_partial_supplied
    assert_render_for_column('widgets/checkbox', :partial => nil, :widget => 'checkbox')
  end
  
  def test_should_render_partial_based_in_partial_if_widget_and_partial_supplied
    assert_render_for_column('should_override', :partial => 'should_override', :widget => 'checkbox')
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    view_instance = Factory.view_instance
    view_instance.stubs(:render)
    instance = Factory.form_builder(:object => object, :template => view_instance)
    instance.render stub_everything(:name => 'a_column')
  end
  
  private
  
  def assert_render_for_column(expected_partial, column_hash)
    column = stub(column_hash.merge(:name => 'the column'))
    object = mock()
    object.stubs(:column_for_attribute).with(:the_column).returns(column)
    object.stubs(:the_column => 'column value')
    builder = builder_instance('an_instance', object, view_instance)
    view_instance.expects(:render).with(:partial => expected_partial, :locals => { :f => builder, :column => column })
    builder.send(helper_method_name, :the_column)
  end
end

# persist_fields
# --------------
class IQ::Helper::FormBuilder::PersistFieldsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Factory.form_builder, :persist_fields
  end

  def test_should_return_empty_string_when_object_does_not_respond_to_persist_columns
    assert_equal '', Factory.form_builder.persist_fields
  end

  def test_should_return_empty_string_when_object_returns_empty_persist_columns
    assert_equal '', Factory.form_builder(:object => stub(:persist_columns => [])).persist_fields
  end

  def test_should_should_return_hidden_field_for_each_column_in_persist_columns_when_object_responds_to_persist_columns
    columns = [stub(:name => 'foo'), stub(:name => 'bar')]
    object = stub(:persist_columns => columns, :foo => 'foo', :bar => 'bar')
    object.stubs(:column_for_attribute).with('foo').returns(columns.first)
    object.stubs(:column_for_attribute).with('bar').returns(columns.last)
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<input id=\"an_instance_changes_foo\" name=\"an_instance[changes][foo]\" type=\"hidden\" value=\"foo\" />" +
      "<input id=\"an_instance_changes_bar\" name=\"an_instance[changes][bar]\" type=\"hidden\" value=\"bar\" />",
      instance.persist_fields
    )
  end
end

# select
# ------
class IQ::Helper::FormBuilder::SelectTest < Test::Unit::TestCase
  def test_should_accept_collection_option
    builder = builder_instance('an_instance', 
      stub(:column_for_attribute => stub(:name => 'something_id'), :something_id => 1), stub_everything()
    )
    assert_nothing_raised(ArgumentError) { builder.select(:something_id, :collection => Proc.new { [['a', 1]] })  }
  end

  def test_should_raise_unless_collection_option_given_in_column_or_helper
    builder = builder_instance('an_instance', 
      stub(
        :column_for_attribute => stub(:name => 'something_id', :options => {}), :something_id => 1
      ), stub_everything()
    )
    assert_raises(ArgumentError) { builder.select(:something_id) }
  end

  def test_should_use_result_of_proc_as_collection_if_proc_given_as_collection_option
    object = stub_everything(:column_for_attribute => stub(:name => 'something_id'))
    instance = Factory.form_builder(:object => object)
    assert_equal(
      "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\">" + 
      "<option value=\"1\">a</option></select>",
      instance.select(:something_id, :collection => Proc.new { [['a', 1]] })
    )
  end

  def test_should_use_result_of_calling_object_class_method_as_collection_if_symbol_given_as_collection_option
    object = stub_everything(
      :column_for_attribute => stub(:name => 'something_id'), :class => stub(:test_collection => [['a', 1]])
    )
    instance = Factory.form_builder(:object => object)
    assert_equal "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\"><option value=\"1\">a</option></select>", instance.select(:something_id, :collection => :test_collection)
  end

  def test_should_use_array_as_collection_if_array_given_as_collection_option
    object = stub_everything(:column_for_attribute => stub(:name => 'something_id'))
    instance = Factory.form_builder(:object => object)
    assert_equal "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\"><option value=\"1\">a</option></select>", instance.select(:something_id, :collection => [['a', 1]])
  end
  
  def test_should_get_called_correctly_with_options_from_column
    object = stub(:something_id => 2)
    object.stubs(:column_for_attribute).with(:something_id).returns(
      stub(:name => 'something_id', :options => { :collection => Proc.new { [['a', 1], ['b', 2]] } })
    )
    instance = Factory.form_builder(:object => object)
    assert_equal "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\"><option value=\"1\">a</option>\n<option value=\"2\" selected=\"selected\">b</option></select>", instance.select(:something_id)
  end
  
  def test_should_not_call_column_for_attribute_on_object_when_column_provided
    object = stub_everything()
    object.expects(:column_for_attribute).never
    instance = Factory.form_builder(:object => object)
    instance.select stub_everything(:name => 'a_column'), :collection => [['a', 1]]
  end
  
  def test_should_use_blank_column_option_as_first_option_tag
    object = stub(:something_id => 2)
    object.stubs(:column_for_attribute).with(:something_id).returns(
      stub(:name => 'something_id', :options => { :collection => Proc.new { [['a', 1], ['b', 2]] }, :blank => 'Create'})
    )
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\">" + 
      "<option value=\"\">Create</option>\n" +
      "<option value=\"1\">a</option>\n<option value=\"2\" selected=\"selected\">b</option>" +
      "</select>",
      instance.select(:something_id)
    )
  end
  
  def test_should_use_blank_option_as_first_option_tag
    object = stub(:something_id => 2)
    object.stubs(:column_for_attribute).with(:something_id).returns(
      stub(:name => 'something_id', :options => { :collection => Proc.new { [['a', 1], ['b', 2]] }})
    )
    instance = Factory.form_builder(:object => object)
    assert_dom_equal(
      "<select id=\"an_instance_something_id\" name=\"an_instance[something_id]\">" + 
      "<option value=\"\">Create</option>\n" +
      "<option value=\"1\">a</option>\n<option value=\"2\" selected=\"selected\">b</option>" +
      "</select>",
      instance.select(:something_id, :blank => 'Create')
    )
  end
end

# group
# -----
class IQ::Helper::FormBuilder::GroupTest < Test::Unit::TestCase
  def test_should_require_column
    flunk 'Not done yet'
  end

  def test_should_render_all_columns_in_group_column
    flunk 'Not done yet'
  end

  def test_should_render_all_columns_in_group_column_with_separator_option
    flunk 'Not done yet'
  end

  def test_should_render_all_columns_in_group_column_with_separator_option_in_column
    flunk 'Not done yet'
  end
end


