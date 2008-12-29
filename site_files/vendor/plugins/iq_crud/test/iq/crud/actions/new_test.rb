require File.join(File.dirname(__FILE__), '..', 'test_helper')

# new
# ---
class IQ::Crud::Actions::New::NewTest < Test::Unit::TestCase
  def setup
    ActionView::Base.any_instance.stubs(:error_messages_for).returns('<p id="errors">Errors</p>')
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:build_member).with().returns(blank_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :new)
  end
  
  def test_should_call_response_for_new_and_return
    crudified_instance.stubs(:response_for).with(:new).returns('the response')
    crudified_instance.stubs(:build_member)
    assert_equal 'the response', crudified_instance.new
  end
  
  def test_should_render_html
    request_with_both_shiny_product_routes(:get, :new) do |prefix|
      assert_response :success
    end
  end
  
  def test_should_render_xml
    setup_xml_request_header
    blank_member.stubs(:to_xml).returns('the xml')
    request_with_shiny_products_route(:get, :new) { assert_equal('the xml', @response.body) }
  end
  
  def test_should_populate_current_member_from_build_member
    request_with_both_shiny_product_routes(:get, :new) do |prefix|
      assert_equal(blank_member, crudified_view.current_member)
    end
  end
  
  def test_should_have_header
    request_with_both_shiny_product_routes(:get, :new) do |prefix|
      assert_select('h1', 'New shiny product')
    end
  end
  
  def test_should_have_error_messages
    request_with_both_shiny_product_routes(:get, :new) do |prefix|
      assert_select('p#errors', 'Errors')
    end
  end
  
  def test_should_have_form
    request_with_both_shiny_product_routes(:get, :new) do |prefix|
      assert_select([
        "form#new_shiny_product.new_shiny_product[method=post][action=?]",
        "/#{prefix.tr('_', '/')}shiny_products"
      ]) do
        assert_select('dl') do
          assert_select(['dt:nth-child(1) label[for=?]', 'shiny_product_name'], 'Name')
          assert_select([
            'dd:nth-child(2) input[type=text][id=?][name=?][maxlength=20]:not([value])',
            'shiny_product_name', 'shiny_product[name]'
          ])
          assert_select(['dt:nth-child(3) label[for=?]', 'shiny_product_brand_name'], 'Brand name')
          assert_select([
            'dd:nth-child(4) input[type=text][id=?][name=?][maxlength=25]:not([value])',
            'shiny_product_brand_name', 'shiny_product[brand_name]'
          ])
        end
        assert_select('p.form-actions') do
          assert_select(['input[type=submit][name=commit][value=?]:first-child', 'Create shiny product'])
          assert_select('span', 'or')
          assert_select(
            ['a[href=?][title="Back to shiny product list"]', send(prefix + 'shiny_products_path')], 'cancel'
          )
        end
      end
    end
  end
end