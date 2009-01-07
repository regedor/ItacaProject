require 'test_helper'

class SoundDocumentPhotosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sound_document_photos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sound_document_photo
    assert_difference('SoundDocumentPhoto.count') do
      post :create, :sound_document_photo => { }
    end

    assert_redirected_to sound_document_photo_path(assigns(:sound_document_photo))
  end

  def test_should_show_sound_document_photo
    get :show, :id => sound_document_photos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sound_document_photos(:one).id
    assert_response :success
  end

  def test_should_update_sound_document_photo
    put :update, :id => sound_document_photos(:one).id, :sound_document_photo => { }
    assert_redirected_to sound_document_photo_path(assigns(:sound_document_photo))
  end

  def test_should_destroy_sound_document_photo
    assert_difference('SoundDocumentPhoto.count', -1) do
      delete :destroy, :id => sound_document_photos(:one).id
    end

    assert_redirected_to sound_document_photos_path
  end
end
