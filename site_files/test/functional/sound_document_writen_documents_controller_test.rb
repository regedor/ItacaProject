require 'test_helper'

class SoundDocumentWritenDocumentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sound_document_writen_documents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sound_document_writen_document
    assert_difference('SoundDocumentWritenDocument.count') do
      post :create, :sound_document_writen_document => { }
    end

    assert_redirected_to sound_document_writen_document_path(assigns(:sound_document_writen_document))
  end

  def test_should_show_sound_document_writen_document
    get :show, :id => sound_document_writen_documents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sound_document_writen_documents(:one).id
    assert_response :success
  end

  def test_should_update_sound_document_writen_document
    put :update, :id => sound_document_writen_documents(:one).id, :sound_document_writen_document => { }
    assert_redirected_to sound_document_writen_document_path(assigns(:sound_document_writen_document))
  end

  def test_should_destroy_sound_document_writen_document
    assert_difference('SoundDocumentWritenDocument.count', -1) do
      delete :destroy, :id => sound_document_writen_documents(:one).id
    end

    assert_redirected_to sound_document_writen_documents_path
  end
end
