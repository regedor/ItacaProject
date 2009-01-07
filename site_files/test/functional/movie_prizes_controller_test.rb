require 'test_helper'

class MoviePrizesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_prizes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movie_prize
    assert_difference('MoviePrize.count') do
      post :create, :movie_prize => { }
    end

    assert_redirected_to movie_prize_path(assigns(:movie_prize))
  end

  def test_should_show_movie_prize
    get :show, :id => movie_prizes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movie_prizes(:one).id
    assert_response :success
  end

  def test_should_update_movie_prize
    put :update, :id => movie_prizes(:one).id, :movie_prize => { }
    assert_redirected_to movie_prize_path(assigns(:movie_prize))
  end

  def test_should_destroy_movie_prize
    assert_difference('MoviePrize.count', -1) do
      delete :destroy, :id => movie_prizes(:one).id
    end

    assert_redirected_to movie_prizes_path
  end
end
