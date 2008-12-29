require File.join(File.dirname(__FILE__), '..', 'test_helper')

# index
# -----
class IQ::Crud::Actions::Index::IndexTest < Test::Unit::TestCase 
  def setup
    ['', 'admin_'].each do |prefix|
      send(prefix + 'crudified_instance').stubs(:find_collection).with().returns(valid_collection)
    end
  end
  
  def test_should_respond
    assert_respond_to(crudified_instance, :index)
  end
  
  def test_should_call_response_for_and_return
    crudified_instance.stubs(:response_for).with(:index).returns('the response')
    assert_equal 'the response', crudified_instance.index
  end
  
  def test_should_render_html
    request_with_both_shiny_product_routes(:get, :index) do |prefix|
      assert_response :success
    end
  end
  
  def test_should_render_xml
    setup_xml_request_header
    valid_collection.stubs(:to_xml).returns('the xml')
    request_with_shiny_products_route(:get, :index) { assert_equal('the xml', @response.body) }
  end
  
  def test_should_populate_current_collection_from_find_collection
    request_with_both_shiny_product_routes(:get, :index) do |prefix|
      assert_equal(valid_collection, send(prefix + 'crudified_view').current_collection)
    end
  end
  
  def test_should_have_header
    request_with_both_shiny_product_routes(:get, :index) { assert_select('h1', 'Shiny products') }
  end
  
  def test_should_have_new_link
    request_with_both_shiny_product_routes(:get, :index) do |prefix|
      assert_select(['p a[href=?]', send("new_#{prefix}shiny_product_path")], 'New shiny product', :count => 2)
    end
  end
  
  def test_should_have_table_of_records
    request_with_both_shiny_product_routes(:get, :index) do |prefix|
      assert_select('table[cellspacing="0"]') do
        assert_select('thead') do
          assert_select('tr th:nth-child(1)', 'Name')
          assert_select('tr th:nth-child(2)', 'Brand name')
          assert_select('tr th:last-child',   'Action')
        end
      
        assert_select('tbody') do
          assert_select('tr:nth-child(1).alt') do
            assert_select('td:nth-child(1)', 'Foo')
            assert_select('td:nth-child(2)', 'Footech')
            assert_select('td:last-child') do
              assert_select(['a[href=?]', send("edit_#{prefix}shiny_product_path",    '21')], 'Edit')
              assert_select(['a[href=?]', send("delete_#{prefix}shiny_product_path",  '21')], 'Delete')
            end
          end
          assert_select('tr:nth-child(2):not(.alt)') do
            assert_select('td:nth-child(1)', 'Bar')
            assert_select('td:nth-child(2)', '&nbsp;')
            assert_select('td:last-child') do
              assert_select(['a[href=?]', send("edit_#{prefix}shiny_product_path",    '35')], 'Edit')
              assert_select(['a[href=?]', send("delete_#{prefix}shiny_product_path",  '35')], 'Delete')
            end
          end
          assert_select('tr:nth-child(3).alt') do
            assert_select('td:nth-child(1)', 'Yum &amp; Baz')
            assert_select('td:nth-child(2)', 'YumBaz Inc.')
            assert_select('td:last-child') do
              assert_select(['a[href=?]', send("edit_#{prefix}shiny_product_path",    '46')], 'Edit')
              assert_select(['a[href=?]', send("delete_#{prefix}shiny_product_path",  '46')], 'Delete')
            end
          end
        end
      end
    end
  end
end