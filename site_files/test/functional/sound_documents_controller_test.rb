require 'test_helper'

class SoundDocumentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sound_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sound_document" do
    assert_difference('SoundDocument.count') do
      post :create, :sound_document => { }
    end

    assert_redirected_to sound_document_path(assigns(:sound_document))
  end

  test "should show sound_document" do
    get :show, :id => sound_documents(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sound_documents(:one).id
    assert_response :success
  end

  test "should update sound_document" do
    put :update, :id => sound_documents(:one).id, :sound_document => { }
    assert_redirected_to sound_document_path(assigns(:sound_document))
  end

  test "should destroy sound_document" do
    assert_difference('SoundDocument.count', -1) do
      delete :destroy, :id => sound_documents(:one).id
    end

    assert_redirected_to sound_documents_path
  end
end
