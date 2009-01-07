require 'test_helper'

class MoviePhotosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_photos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movie_photo
    assert_difference('MoviePhoto.count') do
      post :create, :movie_photo => { }
    end

    assert_redirected_to movie_photo_path(assigns(:movie_photo))
  end

  def test_should_show_movie_photo
    get :show, :id => movie_photos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movie_photos(:one).id
    assert_response :success
  end

  def test_should_update_movie_photo
    put :update, :id => movie_photos(:one).id, :movie_photo => { }
    assert_redirected_to movie_photo_path(assigns(:movie_photo))
  end

  def test_should_destroy_movie_photo
    assert_difference('MoviePhoto.count', -1) do
      delete :destroy, :id => movie_photos(:one).id
    end

    assert_redirected_to movie_photos_path
  end
end
