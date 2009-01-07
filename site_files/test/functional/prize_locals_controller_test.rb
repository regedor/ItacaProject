require 'test_helper'

class PrizeLocalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:prize_locals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_prize_locals
    assert_difference('PrizeLocals.count') do
      post :create, :prize_locals => { }
    end

    assert_redirected_to prize_locals_path(assigns(:prize_locals))
  end

  def test_should_show_prize_locals
    get :show, :id => prize_locals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => prize_locals(:one).id
    assert_response :success
  end

  def test_should_update_prize_locals
    put :update, :id => prize_locals(:one).id, :prize_locals => { }
    assert_redirected_to prize_locals_path(assigns(:prize_locals))
  end

  def test_should_destroy_prize_locals
    assert_difference('PrizeLocals.count', -1) do
      delete :destroy, :id => prize_locals(:one).id
    end

    assert_redirected_to prize_locals_path
  end
end
