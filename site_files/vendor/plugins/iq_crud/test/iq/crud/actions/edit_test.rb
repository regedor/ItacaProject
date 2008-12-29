require File.join(File.dirname(__FILE__), '..', 'test_helper')

# edit
# ----
class IQ::Crud::Actions::Edit::EditTest < Test::Unit::TestCase
  def setup
    ActionView::Base.any_instance.stubs(:error_messages_for).returns('<p id="errors">Errors</p>')
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_member).with().returns(valid_member)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :edit)
  end
  
  def test_should_call_response_for_edit_and_return
    crudified_instance.stubs(:response_for).with(:edit).returns('the response')
    crudified_instance.stubs(:find_member)
    assert_equal 'the response', crudified_instance.edit
  end

  def test_should_render_html
    request_with_both_shiny_product_routes(:get, :edit, :id => 21) do |prefix|
      assert_response :success
    end
  end

  def test_should_populate_current_member_from_find_member
    request_with_both_shiny_product_routes(:get, :edit, :id => 21) do |prefix|
      assert_equal(valid_member, crudified_view.current_member)
    end
  end
  
  def test_should_have_header
    request_with_both_shiny_product_routes(:get, :edit, :id => 21) do |prefix|
      assert_select('h1', 'Edit shiny product')
    end
  end
  
  def test_should_have_error_messages
    request_with_both_shiny_product_routes(:get, :edit, :id => 21) do |prefix|
      assert_select('p#errors', 'Errors')
    end
  end
  
  def test_should_have_form
    request_with_both_shiny_product_routes(:get, :edit, :id => 21) do |prefix|
      assert_select([
        "form#edit_shiny_product_21.edit_shiny_product[method=post][action=?]",
        "/#{prefix.tr('_', '/')}shiny_products/21"
      ]) do
        assert_select('input[type=hidden][name="_method"][value=put]')
        assert_select('dl') do
          assert_select(['dt:nth-child(1) label[for=?]', 'shiny_product_name'], 'Name')
          assert_select([
            'dd:nth-child(2) input[type=text][id=?][name=?][value=?][maxlength=20]',
            'shiny_product_name', 'shiny_product[name]', 'Foo'
          ])
          assert_select(['dt:nth-child(3) label[for=?]', 'shiny_product_brand_name'], 'Brand name')
          assert_select([
            'dd:nth-child(4) input[id=?][name=?][value=?][maxlength=25]',
            'shiny_product_brand_name', 'shiny_product[brand_name]', 'Foo &amp; Bar Inc.'
          ])
        end
        assert_select('p.form-actions') do
          assert_select(['input[type=submit][name=commit][value=?]:first-child', 'Update shiny product'])
          assert_select('span', 'or')
          assert_select(
            ['a[href=?][title="Back to shiny product list"]', send(prefix + 'shiny_products_path')], 'cancel'
          )
        end
      end
    end
  end
end