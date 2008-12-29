require File.join(File.dirname(__FILE__), 'test_helper')

# ----------------------------------------------------------------------------------------------------
# Class Methods
# ----------------------------------------------------------------------------------------------------

# self.included
# -------------
class IQ::Crud::Base::SelfIncludedTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to IQ::Crud::Base, :included
  end

  def test_should_define_helper_methods
    base = stub_everything
    base.expects(:helper_method).with(
      :current_member, :current_collection,
      :resource_finder, :resource_class, :resource_singular, :resource_plural,
      :collection_path, :member_path, :new_member_path, :edit_member_path, :delete_member_path
    )
    IQ::Crud::Base.included(base)
  end

  def test_should_write_inheritable_attribute_for_crudify_config_procs_on_base_class
    base = stub_everything
    base.expects(:write_inheritable_attribute).with(:crudify_config_procs, [])
    IQ::Crud::Base.included(base)
  end

  def test_should_extend_base_class_with_class_methods
    base = stub_everything
    base.expects(:extend).with(IQ::Crud::Base::ClassMethods)
    IQ::Crud::Base.included(base)
  end
end

# crudify_config_procs
# --------------------
class IQ::Crud::Base::CrudifyConfigProcsTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Class.new { extend(IQ::Crud::Base::ClassMethods) }, :crudify_config_procs
  end

  def test_should_return_value_of_read_inheritable_attribute_for_crudify_config_procs
    klass = Class.new { extend(IQ::Crud::Base::ClassMethods) }
    klass.expects(:read_inheritable_attribute).with(:crudify_config_procs)
    klass.crudify_config_procs
  end
end

# crudify_config
# --------------
class IQ::Crud::Base::CrudifyConfigTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to Class.new { extend(IQ::Crud::Base::ClassMethods) }, :crudify_config
  end

  def test_should_raise_when_no_block_given
    klass = Class.new { extend(IQ::Crud::Base::ClassMethods) }
    assert_raise(ArgumentError) { klass.crudify_config }
  end

  def test_should_append_block_to_crudify_config_procs
    klass = Class.new { extend(IQ::Crud::Base::ClassMethods) }
    first_proc  = Proc.new { 'first'  }
    second_proc = Proc.new { 'second' }
    klass.write_inheritable_attribute :crudify_config_procs, [first_proc]
    klass.crudify_config &second_proc
    assert_equal [first_proc, second_proc], klass.crudify_config_procs
  end
end

# ----------------------------------------------------------------------------------------------------
# Instance Methods
# ----------------------------------------------------------------------------------------------------

# current_member
# --------------
class IQ::Crud::Base::CurrentMemberTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :current_member)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :current_member)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :current_member)
  end
  
  def test_should_return_instance_variable_value
    crudified_instance.instance_variable_set('@shiny_product', 'the member')
    assert_equal('the member', crudified_view.current_member)
  end
end

# current_collection
# ------------------
class IQ::Crud::Base::CurrentCollectionTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :current_collection)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :current_collection)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :current_collection)
  end
  
  def test_should_return_instance_variable_value
    crudified_instance.instance_variable_set('@shiny_products', 'the collection')
    assert_equal('the collection', crudified_view.current_collection)
  end
end

# resource_class
# --------------
class IQ::Crud::Base::ResourceClassTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :resource_class)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :resource_class)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :resource_class)
  end
  
  def test_should_be_automatically_determined_from_controller
    assert_equal(model_class, crudified_view.resource_class)
  end

  def test_should_return_custom_class_when_class_supplied
    crudified_instance(AnotherProduct)
    assert_equal(AnotherProduct, crudified_view.resource_class)
  end
  
  def test_should_return_custom_class_when_string_supplied
    crudified_instance('AnotherProduct')
    assert_equal(AnotherProduct, crudified_view.resource_class)
  end
  
  def test_should_return_custom_class_when_string_supplied
    crudified_instance(:another_product)
    assert_equal(AnotherProduct, crudified_view.resource_class)
  end
  
  def test_should_return_name_of_association_classified_when_resource_finder_does_not_return_a_class
    instance = crudified_instance
    instance.stubs(:resource_finder).returns(stub(:name => stub(:classify => 'ShinyProduct')))
    assert_equal ShinyProduct, crudified_view.resource_class
  end
end

# resource_plural
# ---------------
class IQ::Crud::Base::ResourcePluralTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :resource_plural)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :resource_plural)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :resource_plural)
  end
  
  def test_should_be_automatically_determined_from_controller
    assert_equal('shiny_products', crudified_view.resource_plural)
  end
  
  def test_should_be_determined_from_controller_even_if_resource_name_supplied
    crudified_instance(:another_product)
    assert_equal('shiny_products', crudified_view.resource_plural)
  end
end

# resource_singular
# -----------------
class IQ::Crud::Base::ResourceSingularTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :resource_singular)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :resource_singular)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :resource_singular)
  end

  def test_should_be_automatically_determined_from_controller
    assert_equal('shiny_product', crudified_view.resource_singular)
  end
  
  def test_should_be_determined_from_controller_even_if_resource_name_supplied
    crudified_instance(:another_product)
    assert_equal('shiny_product', crudified_view.resource_singular)
  end
end

# new_member_path
# ---------------
class IQ::Crud::Base::NewMemberPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :new_member_path)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :new_member_path)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :new_member_path)
  end
  
  def test_should_return_polymorphic_path
    with_dummy_request do
      assert_equal('/shiny_products/new', crudified_view.new_member_path)
    end
  end
  
  def test_should_return_namespaced_polymorphic_path
    with_admin_dummy_request do
      assert_equal('/admin/shiny_products/new', admin_crudified_view.new_member_path)
    end
  end
end

# edit_member_path
# ----------------
class IQ::Crud::Base::EditMemberPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :edit_member_path)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :edit_member_path)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :edit_member_path)
  end
  
  def test_should_return_polymorphic_path
    with_dummy_request do
      assert_equal('/shiny_products/21/edit', crudified_view.edit_member_path(valid_member))
    end
  end
  
  def test_should_return_namespaced_polymorphic_path
    with_admin_dummy_request do
      assert_equal('/admin/shiny_products/21/edit', admin_crudified_view.edit_member_path(valid_member))
    end
  end
end

# delete_member_path
# ------------------
class IQ::Crud::Base::DeleteMemberPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :delete_member_path)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :delete_member_path)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :delete_member_path)
  end
  
  def test_should_return_polymorphic_path
    with_dummy_request do
      assert_equal('/shiny_products/21/delete', crudified_view.delete_member_path(valid_member))
    end
  end
  
  def test_should_return_namespaced_polymorphic_path
    with_admin_dummy_request do
      assert_equal('/admin/shiny_products/21/delete', admin_crudified_view.delete_member_path(valid_member))
    end
  end
end

# member_path
# -----------
class IQ::Crud::Base::MemberPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :member_path)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :member_path)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :member_path)
  end
  
  def test_should_return_polymorphic_path
    with_dummy_request do
      assert_equal('/shiny_products/21', crudified_view.member_path(valid_member))
    end
  end
  
  def test_should_return_namespaced_polymorphic_path
    with_admin_dummy_request do
      assert_equal('/admin/shiny_products/21', admin_crudified_view.member_path(valid_member))
    end
  end
end

# collection_path
# ---------------
class IQ::Crud::Base::CollectionPathTest < Test::Unit::TestCase
  def test_should_respond
    assert_respond_to(crudified_instance, :collection_path)
  end

  def test_should_be_protected
    assert_protected(crudified_instance, :collection_path)
  end
  
  def test_should_be_helper
    assert_respond_to(crudified_view, :collection_path)
  end
  
  def test_should_return_polymorphic_path
    with_dummy_request do
      assert_equal('/shiny_products', crudified_view.collection_path)
    end
  end
  
  def test_should_return_namespaced_polymorphic_path
    with_admin_dummy_request do
      assert_equal('/admin/shiny_products', admin_crudified_view.collection_path)
    end
  end
end

# ---------------------------------------------------------------------------------------------------------
# Private Methods - do not normally test private methods, needed here as used when defining controllers
# ---------------------------------------------------------------------------------------------------------

# response_for
# ------------
class IQ::Crud::Base::ResponseForTest < Test::Unit::TestCase
  def test_should_raise_unless_action_is_given_as_symbol
    assert_raise(ArgumentError) { crudified_instance.send(:response_for, 'not a symbol') }
  end

  def test_should_call_respond_to_with_results_from_crudify_responses_inheritable_attribute
    Factory.with_temp_class('MyProductsController', ActionController::Base) do |klass|
      klass.crudify :shiny_product
  
      klass.class_eval do
        def index
          response_for :index
        end
      end
      
      klass.read_inheritable_attribute(:crudify_responses)[:index] = [
        [:html, Proc.new { render :text => 'html format' }],
        [:atom, Proc.new { render :text => 'atom format' }]
      ]
      
      @controller = klass.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      
      with_routing do |set|
        set.draw { |map| map.resources :my_products }

        get :index, :format => 'html'
        assert_equal 'html format', @response.body

        get :index, :format => 'atom'
        assert_equal 'atom format', @response.body
      end
    end
  end
end

# find_member
# -----------
class IQ::Crud::Base::FindMemberTest < Test::Unit::TestCase
  def test_should_find_with_param_id_by_default
    params = mock()
    params.expects(:[]).with(:id).returns('the id')
    crudified_instance.expects(:params).returns(params)
    model_class.expects(:find).with('the id').returns('the member')
    assert_equal('the member', crudified_instance.send(:find_member))
  end
  
  def test_should_use_member_symbol_if_supplied
    crudified_instance(:member => :find_in_stange_way)
    params = mock()
    params.expects(:[]).with(:id).returns('the id')
    crudified_instance.expects(:params).returns(params)
    model_class.expects(:find_in_stange_way).with('the id').returns('strange member')
    assert_equal('strange member', crudified_instance.send(:find_member))
  end
  
  def test_should_use_member_proc_if_supplied
    params = mock()
    params.expects(:[]).with(:another).returns('the param')
    crudified_instance(:member => Proc.new { |finder| finder.custom_find(params[:another]) })
    model_class.expects(:custom_find).with('the param').returns('the member')
    assert_equal('the member', crudified_instance.send(:find_member))
  end
  
  # Proxying
  # --------
  def test_should_yield_resource_finder_when_calling_member_proc
    crudified_instance(:finder => Proc.new { test_proxy_object() })
    crudified_instance.stubs(:params).returns(stub(:[]))
    crudified_instance.expects(:test_proxy_object).returns(mock(:find => 'the member'))
    assert_equal('the member', crudified_instance.send(:find_member))
  end
  
  def test_should_use_resource_finder_symbol_option_if_supplied
    crudified_instance(:finder => :account_projects)
    crudified_instance.stubs(:params).returns(stub(:[]))
    account = mock(:find => 'proxied results')
    crudified_instance.expects(:account_projects).returns(account)
    assert_equal('proxied results', crudified_instance.send(:find_member))
  end
  
  def test_should_use_resource_finder_proc_option_if_supplied
    account = mock(:find => 'proxied results')
    crudified_instance(:finder => Proc.new { account })
    crudified_instance.stubs(:params).returns(stub(:[]))
    assert_equal('proxied results', crudified_instance.send(:find_member))
  end
end

# find_collection
# ---------------
class IQ::Crud::Base::FindCollectionTest < Test::Unit::TestCase
  def test_should_find_all_by_default
    model_class.expects(:find).with(:all).returns('all records')
    assert_equal('all records', crudified_instance.send(:find_collection))
  end
  
  def test_should_use_collection_symbol_if_supplied
    crudified_instance(:collection => :find_most_recent)
    model_class.expects(:find_most_recent).with().returns('most recent')
    assert_equal('most recent', crudified_instance.send(:find_collection))
  end

  def test_should_use_collection_proc_if_supplied
    crudified_instance(:collection => Proc.new { |finder| finder.find_most_recent(10) })
    model_class.expects(:find_most_recent).with(10).returns('most recent')
    assert_equal('most recent', crudified_instance.send(:find_collection))
  end
  
  # Proxying
  # --------
  def test_should_yield_finder_when_calling_collection_proc
    crudified_instance(:finder => Proc.new { test_collection_proxy_object() })
    crudified_instance.stubs(:test_collection_proxy_object).returns(mock(:find => 'most recent'))
    assert_equal('most recent', crudified_instance.send(:find_collection))
  end
  
  def test_should_use_finder_option_symbol_if_supplied
    crudified_instance(:finder => :account_projects)
    account = mock()
    account.expects(:find).returns('proxied results')
    crudified_instance.expects(:account_projects).returns(account)
    assert_equal('proxied results', crudified_instance.send(:find_collection))
  end
  
  def test_should_use_finder_option_proc_if_supplied
    account = mock()
    account.expects(:find).returns('proxied results')
    crudified_instance(:finder => Proc.new { account })
    assert_equal('proxied results', crudified_instance.send(:find_collection))
  end
end

# build_member
# ------------
class IQ::Crud::Base::BuildMemberTest < Test::Unit::TestCase
  def test_should_use_new_method_if_resource_finder_is_a_class
    model_class.expects(:new).with().returns('new member')
    assert_equal('new member', crudified_instance.send(:build_member))
  end
  
  def test_should_use_build_in_place_of_new_if_resource_finder_is_not_a_class
    proxy = mock()
    proxy.expects(:build).with().returns('proxied member')
    crudified_instance(:finder => Proc.new { proxy })
    assert_equal('proxied member', crudified_instance.send(:build_member))
  end
  
  def test_should_use_build_symbol_when_supplied
    crudified_instance(:build => :build_my_member)
    model_class.expects(:build_my_member).with().returns('new member')
    assert_equal('new member', crudified_instance.send(:build_member))
  end
  
  def test_should_use_build_proc_when_supplied
    crudified_instance(:build => Proc.new { |finder| finder.special_build })
    model_class.expects(:special_build).with().returns('new member')
    assert_equal('new member', crudified_instance.send(:build_member))
  end
  
  def test_should_take_optional_hash_and_pass_to_new
    model_class.expects(:new).with({ :name => 'Test hash' }).returns('populated member')
    assert_equal('populated member', crudified_instance.send(:build_member, { :name => 'Test hash' }))
  end
  
  def test_should_take_optional_hash_and_pass_to_build
    proxy = mock()
    proxy.expects(:build).with({ :name => 'Test hash' }).returns('populated proxied member')
    crudified_instance(:finder => Proc.new { proxy })
    assert_equal('populated proxied member', crudified_instance.send(:build_member, { :name => 'Test hash' }))
  end
end