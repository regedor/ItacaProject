require 'test_helper'

class ContriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contry" do
    assert_difference('Contry.count') do
      post :create, :contry => { }
    end

    assert_redirected_to contry_path(assigns(:contry))
  end

  test "should show contry" do
    get :show, :id => contries(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => contries(:one).id
    assert_response :success
  end

  test "should update contry" do
    put :update, :id => contries(:one).id, :contry => { }
    assert_redirected_to contry_path(assigns(:contry))
  end

  test "should destroy contry" do
    assert_difference('Contry.count', -1) do
      delete :destroy, :id => contries(:one).id
    end

    assert_redirected_to contries_path
  end
end
