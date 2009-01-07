require 'test_helper'

class PhotoLocalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_locals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_photo_locals
    assert_difference('PhotoLocals.count') do
      post :create, :photo_locals => { }
    end

    assert_redirected_to photo_locals_path(assigns(:photo_locals))
  end

  def test_should_show_photo_locals
    get :show, :id => photo_locals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => photo_locals(:one).id
    assert_response :success
  end

  def test_should_update_photo_locals
    put :update, :id => photo_locals(:one).id, :photo_locals => { }
    assert_redirected_to photo_locals_path(assigns(:photo_locals))
  end

  def test_should_destroy_photo_locals
    assert_difference('PhotoLocals.count', -1) do
      delete :destroy, :id => photo_locals(:one).id
    end

    assert_redirected_to photo_locals_path
  end
end
