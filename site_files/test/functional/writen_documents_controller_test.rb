require 'test_helper'

class WritenDocumentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:writen_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create writen_document" do
    assert_difference('WritenDocument.count') do
      post :create, :writen_document => { }
    end

    assert_redirected_to writen_document_path(assigns(:writen_document))
  end

  test "should show writen_document" do
    get :show, :id => writen_documents(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => writen_documents(:one).id
    assert_response :success
  end

  test "should update writen_document" do
    put :update, :id => writen_documents(:one).id, :writen_document => { }
    assert_redirected_to writen_document_path(assigns(:writen_document))
  end

  test "should destroy writen_document" do
    assert_difference('WritenDocument.count', -1) do
      delete :destroy, :id => writen_documents(:one).id
    end

    assert_redirected_to writen_documents_path
  end
end
