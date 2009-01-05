require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/controllers/view_path_controller'

class ViewPathController; def rescue_action(e) raise e end; end

class IQ::ViewPathExtensions::BaseTest < Test::Unit::TestCase
  def setup
    @controller = ViewPathController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_accept_exclude_controller_path_option_for_prepend_and_append_view_path
    assert_nothing_raised do
      ViewPathController.append_view_path(File.dirname(__FILE__) + '/views', :exclude_controller_path => true)
    end
    assert_nothing_raised do
      ViewPathController.prepend_view_path(File.dirname(__FILE__) + '/views', :exclude_controller_path => true)
    end
  end
  
  def test_should_not_break_existing_api
    assert_nothing_raised do
      ViewPathController.append_view_path(File.dirname(__FILE__) + '/views')
    end
    assert_nothing_raised do
      ViewPathController.prepend_view_path(File.dirname(__FILE__) + '/views')
    end
  end
  
  def test_should_apply_controller_path_exclusion_correctly
    ViewPathController.append_view_path(File.dirname(__FILE__) + '/views', :exclude_controller_path => true)
    with_routing do |set|
      set.draw do |map|
        map.connect 'view_path/example', :controller => 'view_path', :action => 'example'
      end
      get :example
      assert_not_nil assigns['example']
      assert_response :success
      assert_select 'span', 'TEST PARTIAL', 'Should have included partial'
    end
  end
end