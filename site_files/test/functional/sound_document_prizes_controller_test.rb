require 'test_helper'

class SoundDocumentPrizesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sound_document_prizes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sound_document_prize
    assert_difference('SoundDocumentPrize.count') do
      post :create, :sound_document_prize => { }
    end

    assert_redirected_to sound_document_prize_path(assigns(:sound_document_prize))
  end

  def test_should_show_sound_document_prize
    get :show, :id => sound_document_prizes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sound_document_prizes(:one).id
    assert_response :success
  end

  def test_should_update_sound_document_prize
    put :update, :id => sound_document_prizes(:one).id, :sound_document_prize => { }
    assert_redirected_to sound_document_prize_path(assigns(:sound_document_prize))
  end

  def test_should_destroy_sound_document_prize
    assert_difference('SoundDocumentPrize.count', -1) do
      delete :destroy, :id => sound_document_prizes(:one).id
    end

    assert_redirected_to sound_document_prizes_path
  end
end
