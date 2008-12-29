require File.join(File.dirname(__FILE__), '..', 'test_helper')

# show
# -----
class IQ::Crud::Actions::Show::ShowTest < Test::Unit::TestCase 
  def setup    
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_member).with().returns(valid_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :show)
  end
  
  def test_should_call_response_for_show_and_return
    crudified_instance.stubs(:response_for).with(:show).returns('the response')
    crudified_instance.stubs(:find_member)
    assert_equal 'the response', crudified_instance.show
  end

  def test_should_render_html
    request_with_both_shiny_product_routes(:get, :show, :id => 21) do |prefix|
      assert_response :success
    end
  end
  
  def test_should_render_xml
    setup_xml_request_header
    valid_member.stubs(:to_xml).returns('the xml')
    request_with_shiny_products_route(:get, :show, :id => 21) { assert_equal('the xml', @response.body) }
  end
  
  def test_should_populate_current_member_from_find_member
    request_with_both_shiny_product_routes(:get, :show, :id => 21) do
      assert_equal(valid_member, crudified_view.current_member)
    end
  end
  
  def test_should_have_list_of_fields
    request_with_both_shiny_product_routes(:get, :show, :id => 21) do
      assert_select('dl') do
        assert_select('dt:nth-child(1) strong', 'Name')
        assert_select('dd:nth-child(2)', 'Foo')
        assert_select('dt:nth-child(3) strong', 'Brand name')
        assert_select('dd:nth-child(4)', 'Foo &amp; Bar Inc.')
      end
    end
  end
  
  def test_should_have_back_link
    request_with_both_shiny_product_routes(:get, :show, :id => 21) do |prefix|
      assert_select(['p a[href=?]', send("#{prefix}shiny_products_path")], '&laquo; Back')
    end
  end
  
  def test_should_have_edit_link
    request_with_both_shiny_product_routes(:get, :show, :id => 21) do |prefix|
      assert_select(['p a[href=?]', send("edit_#{prefix}shiny_product_path", '21')], 'Edit')
    end
  end
end