require 'test_helper'

class WritenDocumentLocalsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:writen_document_locals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_writen_document_locals
    assert_difference('WritenDocumentLocals.count') do
      post :create, :writen_document_locals => { }
    end

    assert_redirected_to writen_document_locals_path(assigns(:writen_document_locals))
  end

  def test_should_show_writen_document_locals
    get :show, :id => writen_document_locals(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => writen_document_locals(:one).id
    assert_response :success
  end

  def test_should_update_writen_document_locals
    put :update, :id => writen_document_locals(:one).id, :writen_document_locals => { }
    assert_redirected_to writen_document_locals_path(assigns(:writen_document_locals))
  end

  def test_should_destroy_writen_document_locals
    assert_difference('WritenDocumentLocals.count', -1) do
      delete :destroy, :id => writen_document_locals(:one).id
    end

    assert_redirected_to writen_document_locals_path
  end
end
