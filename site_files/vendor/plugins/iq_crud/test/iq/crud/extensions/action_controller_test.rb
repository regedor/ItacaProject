require File.join(File.dirname(__FILE__), '../test_helper')

# -----------------------------------------------------------------------------------------------
# Class Methods
# -----------------------------------------------------------------------------------------------

# crudify
# -------
class IQ::Crud::Extensions::ActionController::CrudifyClassMethodTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(ActionController::Base, :crudify)
  end
  
  def test_should_validate_args
    assert_raise(ArgumentError) { controller_class.crudify(321) }
    assert_raise(ArgumentError) { controller_class.crudify(:shiny_product, 'not a hash') }
    assert_nothing_raised { controller_class.crudify(:shiny_product, :a_key => 'a value') }
    assert_nothing_raised { controller_class.crudify(model_class) }
    assert_nothing_raised { controller_class.crudify('ShinyProduct') }
    assert_nothing_raised { controller_class.crudify(:shiny_product) }
  end
  
  def test_should_validate_collection_option
    assert_raise(ArgumentError) { controller_class.crudify(:collection => 'not a sym or proc') }
    assert_nothing_raised { controller_class.crudify(:collection => :most_recent) }
    assert_nothing_raised { controller_class.crudify(:collection => Proc.new { |f| f.find_recent }) }
  end
  
  def test_should_raise_if_both_except_and_only_options_supplied
    assert_raise(ArgumentError) { controller_class.crudify(:only => [], :exclude => []) }
  end
  
  def test_should_raise_when_both_finder_option_supplied_and_first_argument_given
    assert_raise(ArgumentError) { controller_class.crudify(:shiny_product, :finder => stub_everything) }
  end
  
  def test_should_validate_except_and_only_options
    [:only, :exclude].each do |option|
      assert_raise(ArgumentError) { controller_class.crudify(option => :not_crud_action) }
      assert_raise(ArgumentError) { controller_class.crudify(option => [:show, :not_crud_action]) }
      assert_nothing_raised { controller_class.crudify(option => :show) }
      assert_nothing_raised do
        controller_class.crudify(option => [:index, :show, :new, 'create', :edit, :update, :delete, :destroy])
      end
    end
  end
  
  def test_should_load_helper_module
    controller_class.expects(:helper).with(IQ::Crud::Helper)
    controller_class.crudify
  end
  
  def test_should_include_base_module
    controller_class.stubs(:include)
    controller_class.expects(:include).with(IQ::Crud::Base)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.crudify
  end
  
  def test_should_not_include_modules_set_to_be_excluded
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Create).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Delete).never
    
    controller_class.crudify :exclude => [:create, :delete]
  end
  
  def test_should_only_include_specified_modules_if_only_option_set
    controller_class.expects(:include).with(IQ::Crud::Base)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Index).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Show).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Edit).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Create)
    controller_class.expects(:include).with(IQ::Crud::Actions::Edit).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Update).never
    controller_class.expects(:include).with(IQ::Crud::Actions::Delete)
    controller_class.expects(:include).with(IQ::Crud::Actions::Destroy).never
    
    controller_class.crudify :only => [:create, :delete]
  end
  
  def test_should_include_index_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Index)
    controller_class.crudify
  end
  
  def test_should_include_new_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::New)
    controller_class.crudify
  end
  
  def test_should_include_create_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Create)
    controller_class.crudify
  end
  
  def test_should_include_show_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Show)
    controller_class.crudify
  end
  
  def test_should_include_edit_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Edit)
    controller_class.crudify
  end
  
  def test_should_include_update_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Update)
    controller_class.crudify
  end

  def test_should_include_delete_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Delete)
    controller_class.crudify
  end
  
  def test_should_include_destroy_module_by_default
    controller_class.stubs(:include)
    controller_class.stubs(:crudify_config_procs).returns([])
    controller_class.expects(:include).with(IQ::Crud::Actions::Destroy)
    controller_class.crudify
  end
  
  def test_should_instance_eval_each_proc_in_crudify_config_procs_on_base_handler_instance
    proc_1 = Proc.new { 'foo' }
    proc_2 = Proc.new { 'bar' }
    controller_class.stubs(:crudify_config_procs).returns([proc_1, proc_2])
    mock_handler = stub_everything
    mock_handler.expects(:instance_eval).with(&proc_1)
    mock_handler.expects(:instance_eval).with(&proc_2)
    IQ::Crud::BaseHandler.stubs(:new).with().returns(mock_handler)
    controller_class.crudify :only => []
  end
  
  def test_should_instance_eval_block_on_base_handler_instance_when_block_given
    my_proc = Proc.new { 'crudify proc' }
    mock_handler = stub_everything
    mock_handler.expects(:instance_eval).with(&my_proc)
    IQ::Crud::BaseHandler.stubs(:new).with().returns(mock_handler)
    controller_class.crudify :only => [], &my_proc
  end
  
  def test_should_instance_eval_block_on_base_handler_instance_after_config_procs_when_block_given
    my_proc = Proc.new { 'crudify proc' }
    proc_1 = Proc.new { 'foo' }
    proc_2 = Proc.new { 'bar' }
    controller_class.stubs(:crudify_config_procs).returns([proc_1, proc_2])
    mock_handler = stub_everything
    # TODO: Mocha doesn't seem to care about the order of the expectations... investigate
    mock_handler.expects(:instance_eval).with(&proc_1)
    mock_handler.expects(:instance_eval).with(&proc_2)
    mock_handler.expects(:instance_eval).with(&my_proc)
    IQ::Crud::BaseHandler.stubs(:new).with().returns(mock_handler)
    controller_class.crudify :only => [], &my_proc
  end
  
  def test_should_set_crudify_responses_inheritable_attribute_to_value_of_base_handler_instance_responses
    mock_handler = mock()
    mock_handler.stubs(:responses).returns('the responses')
    IQ::Crud::BaseHandler.stubs(:new).with().returns(mock_handler)
    controller_class.crudify :only => []
    assert_equal 'the responses', controller_class.read_inheritable_attribute(:crudify_responses)
  end
end