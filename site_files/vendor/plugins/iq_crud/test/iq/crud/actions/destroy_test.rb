require File.join(File.dirname(__FILE__), '..', 'test_helper')

# destroy
# -------
class IQ::Crud::Actions::Destroy::DeleteTest < Test::Unit::TestCase
  def setup
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_member).with().returns(valid_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :destroy)
  end
  
  def test_should_call_response_for_destroy_and_return_for_successful_destroy
    crudified_instance.stubs(:response_for).with(:destroy).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:find_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:destroy => true))
    assert_equal 'the response', crudified_instance.destroy
  end
  
  def test_should_call_response_for_destroy_failed_and_return_for_unsuccessful_destroy
    crudified_instance.stubs(:response_for).with(:destroy_failed).returns('the response')
    crudified_instance.stubs(:params).returns(stub_everything)
    crudified_instance.stubs(:flash).returns(stub_everything)
    crudified_instance.stubs(:find_member)
    crudified_instance.stubs(:current_member).returns(stub_everything(:destroy => false))
    assert_equal 'the response', crudified_instance.destroy
  end
  
  def test_should_populate_current_member_from_find_member
    valid_member.stubs(:destroy).with()
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do |prefix|
      assert_equal(valid_member, send(prefix + 'crudified_view').current_member)
    end
  end

  def test_should_call_destroy
    valid_member.expects(:destroy).with().times(2)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {})
  end
  
  def test_should_set_flash_success_message_when_saved
    valid_member.stubs(:destroy).with().returns(true)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do
      assert_equal('Shiny product has been deleted.', flash[:success])
    end
  end
  
  def test_should_set_flash_failure_message_when_not_saved
    valid_member.stubs(:destroy).with().returns(false)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do
      assert_equal('Shiny product could not be deleted.', flash[:failure])
    end
  end
    
  def test_should_refirect_after_successful_destroy
    valid_member.stubs(:destroy).with().returns(true)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do |prefix|
      assert_redirected_to send(prefix + 'shiny_products_path')
    end
  end
  
  def test_should_render_delete_after_failed_destroy
    valid_member.stubs(:destroy).with().returns(false)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do |prefix|
      assert_response :success
      assert_template 'delete'
    end
  end
  
  def test_should_render_xml_for_successful_destroy
    setup_xml_request_header
    valid_member.stubs(:destroy).with().returns(true)
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do |prefix|
      assert_response :success
      assert_equal('200 OK', @response.headers['Status'])
      assert_equal(' ', @response.body)
    end
  end
  
  def test_should_render_errors_as_xml_for_failed_save
    setup_xml_request_header
    valid_member.stubs(:destroy).with().returns(false)
    valid_member.stubs(:to_xml).returns('failure xml')
    request_with_both_shiny_product_routes(:delete, :destroy, :id => 21, :shiny_product => {}) do |prefix|
      assert_response :unprocessable_entity
      assert_equal('failure xml', @response.body)
    end
  end
end