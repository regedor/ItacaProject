require File.join(File.dirname(__FILE__), '..', 'test_helper')

# delete
# ------
class IQ::Crud::Actions::Delete::DeleteTest < Test::Unit::TestCase
  def setup
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_member).with().returns(valid_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :delete)
  end
  
  def test_should_call_response_for_delete_and_return
    crudified_instance.stubs(:response_for).with(:delete).returns('the response')
    crudified_instance.stubs(:find_member)
    assert_equal 'the response', crudified_instance.delete
  end

  def test_should_render_html
    request_with_both_shiny_product_routes(:get, :delete, :id => 21) do |prefix|
      assert_response :success
    end
  end

  def test_should_populate_current_member_from_find_member
    request_with_both_shiny_product_routes(:get, :delete, :id => 21) do |prefix|
      assert_equal(valid_member, crudified_view.current_member)
    end
  end
  
  def test_should_have_header
    request_with_both_shiny_product_routes(:get, :delete, :id => 21) do |prefix|
      assert_select('h1', 'Delete shiny product')
    end
  end
  
  def test_should_have_form
    request_with_both_shiny_product_routes(:get, :delete, :id => 21) do |prefix|
      assert_select([
        "form#delete_shiny_product_21.delete_shiny_product[method=post][action=?]",
        "/#{prefix.tr('_', '/')}shiny_products/21"
      ]) do
        assert_select('input[type=hidden][name="_method"][value=delete]')
        assert_select('p:first-of-type', 'Are you sure you wish to delete this shiny product?')
        assert_select('p.form-actions') do
          assert_select(['input[type=submit][name=commit][value=?]:first-child', 'Delete shiny product'])
          assert_select('span', 'or')
          assert_select(
            ['a[href=?][title="Back to shiny product list"]', send(prefix + 'shiny_products_path')], 'cancel'
          )
        end
      end
    end
  end
end