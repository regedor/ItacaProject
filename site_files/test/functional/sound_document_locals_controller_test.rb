require 'test_helper'

class SoundDocumentLocalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sound_document_locals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sound_document_locals
    assert_difference('SoundDocumentLocals.count') do
      post :create, :sound_document_locals => { }
    end

    assert_redirected_to sound_document_locals_path(assigns(:sound_document_locals))
  end

  def test_should_show_sound_document_locals
    get :show, :id => sound_document_locals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sound_document_locals(:one).id
    assert_response :success
  end

  def test_should_update_sound_document_locals
    put :update, :id => sound_document_locals(:one).id, :sound_document_locals => { }
    assert_redirected_to sound_document_locals_path(assigns(:sound_document_locals))
  end

  def test_should_destroy_sound_document_locals
    assert_difference('SoundDocumentLocals.count', -1) do
      delete :destroy, :id => sound_document_locals(:one).id
    end

    assert_redirected_to sound_document_locals_path
  end
end
