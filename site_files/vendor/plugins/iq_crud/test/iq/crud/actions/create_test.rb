require File.join(File.dirname(__FILE__), '..', 'test_helper')

# create
# ------
class IQ::Crud::Actions::Create::CreateTest < Test::Unit::TestCase
  def setup
    ActionView::Base.any_instance.stubs(:error_messages_for).returns('<p id="errors">Errors</p>')
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:build_member).with().returns(blank_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :create)
  end
  
  def test_should_call_response_for_create_and_return_for_successful_save
    crudified_instance.stubs(:response_for).with(:create).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:build_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:save => true))
    assert_equal 'the response', crudified_instance.create
  end
  
  def test_should_call_response_for_create_failed_and_return_for_unsuccessful_save
    crudified_instance.stubs(:response_for).with(:create_failed).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:build_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:save => false))
    assert_equal 'the response', crudified_instance.create
  end
  
  def test_should_populate_current_member_from_build_member
    blank_member.stubs(:save).with().returns(true)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do |prefix|
      assert_equal(blank_member, send(prefix + 'crudified_view').current_member)
    end
  end
  
  def test_should_set_attributes_from_params
    blank_member.stubs(:save).with().returns(true)

    request_with_both_shiny_product_routes(:post, :create,
      :shiny_product => {:name => 'iPod', :brand_name => 'Apple'}
    ) do |prefix|
      assert_equal('iPod', blank_member.name)
      assert_equal('Apple', blank_member.brand_name)
    end
  end
  
  def test_should_call_save
    blank_member.expects(:save).with().returns(true).times(2)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {})
  end
  
  def test_should_set_flash_success_message_when_saved
    blank_member.stubs(:save).with().returns(true)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do
      assert_equal('Shiny product was successfully created.', flash[:success])
    end
  end
  
  def test_should_not_set_flash_success_message_when_not_saved
    blank_member.stubs(:save).with().returns(false)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do
      assert_nil(flash[:success])
    end
  end
  
  def test_should_refirect_after_successful_save
    blank_member.stubs(:save).with().returns(true)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do |prefix|
      assert_redirected_to send(prefix + 'shiny_products_path')
    end
  end
  
  def test_should_render_new_on_failed_save
    blank_member.stubs(:save).with().returns(false)
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do
      assert_response :success
      assert_template 'new'
    end    
  end
  
  def test_should_render_xml_for_successful_save
    setup_xml_request_header
    blank_member.stubs(:save).with().returns(true)
    blank_member.stubs(:new_record?).returns(false)
    blank_member.stubs(:id).returns(21)
    blank_member.stubs(:to_xml).returns('success xml')
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do |prefix|
      assert_response :created
      assert_equal(send(prefix + 'shiny_product_path', 21), @response.headers['Location'])
      assert_equal('success xml', @response.body)
    end
  end
  
  def test_should_render_errors_as_xml_for_failed_save
    setup_xml_request_header
    blank_member.stubs(:save).with().returns(false)
    blank_member.stubs(:errors).returns(stub(:to_xml => 'failure xml'))
    request_with_both_shiny_product_routes(:post, :create, :shiny_product => {}) do |prefix|
      assert_response :unprocessable_entity
      assert_equal('failure xml', @response.body)
    end
  end
end