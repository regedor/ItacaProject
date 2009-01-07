require 'test_helper'

class PhotoPrizesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_prizes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_photo_prize
    assert_difference('PhotoPrize.count') do
      post :create, :photo_prize => { }
    end

    assert_redirected_to photo_prize_path(assigns(:photo_prize))
  end

  def test_should_show_photo_prize
    get :show, :id => photo_prizes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => photo_prizes(:one).id
    assert_response :success
  end

  def test_should_update_photo_prize
    put :update, :id => photo_prizes(:one).id, :photo_prize => { }
    assert_redirected_to photo_prize_path(assigns(:photo_prize))
  end

  def test_should_destroy_photo_prize
    assert_difference('PhotoPrize.count', -1) do
      delete :destroy, :id => photo_prizes(:one).id
    end

    assert_redirected_to photo_prizes_path
  end
end
