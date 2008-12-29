require File.join(File.dirname(__FILE__), '..', 'test_helper')

# update
# ------
class IQ::Crud::Actions::Update::UpdateTest < Test::Unit::TestCase
  def setup
    ActionView::Base.any_instance.stubs(:error_messages_for).returns('<p id="errors">Errors</p>')
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_member).with().returns(valid_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :update)
  end
  
  def test_should_call_response_for_update_and_return_for_successful_save
    crudified_instance.stubs(:response_for).with(:update).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:find_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:update_attributes => true))
    assert_equal 'the response', crudified_instance.update
  end
  
  def test_should_call_response_for_update_failed_and_return_for_unsuccessful_save
    crudified_instance.stubs(:response_for).with(:update_failed).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:find_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:update_attributes => false))
    assert_equal 'the response', crudified_instance.update
  end
  
  def test_should_populate_current_member_from_find_member
    valid_member.stubs(:save).returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do |prefix|
      assert_equal(valid_member, send(prefix + 'crudified_view').current_member)
    end
  end
  
  def test_should_set_attributes_from_params
    valid_member.stubs(:save).returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, 
      :shiny_product => {:name => 'iPod', :brand_name => 'Apple'}
    ) do
      assert_equal('iPod',  valid_member.name)
      assert_equal('Apple', valid_member.brand_name)
    end
  end

  def test_should_call_save
    valid_member.expects(:save).with().returns(true).times(2)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {})
  end
  
  def test_should_set_flash_success_message_when_saved
    valid_member.stubs(:save).with().returns(true)
    valid_member.stubs(:new_record?).returns(false)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do
      assert_equal('Shiny product was successfully updated.', flash[:success])
    end
  end
  
  def test_should_not_set_flash_success_message_when_not_saved
    valid_member.stubs(:save).with().returns(false)
    valid_member.stubs(:new_record?).returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do
      assert_nil(flash[:success])
    end
  end
  
  def test_should_refirect_after_successful_save
    valid_member.stubs(:save).with().returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do |prefix|
      assert_redirected_to send(prefix + 'shiny_products_path')
    end
  end
  
  def test_should_render_edit_on_failed_save
    valid_member.stubs(:save).with().returns(false)
    valid_member.stubs(:new_record?).returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do
      assert_response :success
      assert_template 'edit'
    end    
  end
  
  def test_should_render_xml_for_successful_save
    setup_xml_request_header
    valid_member.stubs(:save).with().returns(true)
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do |prefix|
      assert_response :success
      assert_equal('200 OK', @response.headers['Status'])
      assert_equal(' ', @response.body)
    end
  end
  
  def test_should_render_errors_as_xml_for_failed_save
    setup_xml_request_header
    valid_member.stubs(:save).with().returns(false)
    valid_member.stubs(:errors).returns(stub(:to_xml => 'failure xml'))
    request_with_both_shiny_product_routes(:put, :update, :id => 21, :shiny_product => {}) do |prefix|
      assert_response :unprocessable_entity
      assert_equal('failure xml', @response.body)
    end
  end
end