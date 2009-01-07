require 'test_helper'

class MovieWritenDocumentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_writen_documents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movie_writen_document
    assert_difference('MovieWritenDocument.count') do
      post :create, :movie_writen_document => { }
    end

    assert_redirected_to movie_writen_document_path(assigns(:movie_writen_document))
  end

  def test_should_show_movie_writen_document
    get :show, :id => movie_writen_documents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movie_writen_documents(:one).id
    assert_response :success
  end

  def test_should_update_movie_writen_document
    put :update, :id => movie_writen_documents(:one).id, :movie_writen_document => { }
    assert_redirected_to movie_writen_document_path(assigns(:movie_writen_document))
  end

  def test_should_destroy_movie_writen_document
    assert_difference('MovieWritenDocument.count', -1) do
      delete :destroy, :id => movie_writen_documents(:one).id
    end

    assert_redirected_to movie_writen_documents_path
  end
end
