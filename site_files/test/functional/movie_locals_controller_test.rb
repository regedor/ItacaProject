require 'test_helper'

class MovieLocalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_locals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movie_locals
    assert_difference('MovieLocals.count') do
      post :create, :movie_locals => { }
    end

    assert_redirected_to movie_locals_path(assigns(:movie_locals))
  end

  def test_should_show_movie_locals
    get :show, :id => movie_locals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movie_locals(:one).id
    assert_response :success
  end

  def test_should_update_movie_locals
    put :update, :id => movie_locals(:one).id, :movie_locals => { }
    assert_redirected_to movie_locals_path(assigns(:movie_locals))
  end

  def test_should_destroy_movie_locals
    assert_difference('MovieLocals.count', -1) do
      delete :destroy, :id => movie_locals(:one).id
    end

    assert_redirected_to movie_locals_path
  end
end
