require 'test_helper'

class WritenDocumentPhotosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:writen_document_photos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_writen_document_photo
    assert_difference('WritenDocumentPhoto.count') do
      post :create, :writen_document_photo => { }
    end

    assert_redirected_to writen_document_photo_path(assigns(:writen_document_photo))
  end

  def test_should_show_writen_document_photo
    get :show, :id => writen_document_photos(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => writen_document_photos(:one).id
    assert_response :success
  end

  def test_should_update_writen_document_photo
    put :update, :id => writen_document_photos(:one).id, :writen_document_photo => { }
    assert_redirected_to writen_document_photo_path(assigns(:writen_document_photo))
  end

  def test_should_destroy_writen_document_photo
    assert_difference('WritenDocumentPhoto.count', -1) do
      delete :destroy, :id => writen_document_photos(:one).id
    end

    assert_redirected_to writen_document_photos_path
  end
end
