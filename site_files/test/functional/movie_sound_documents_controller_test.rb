require 'test_helper'

class MovieSoundDocumentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_sound_documents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movie_sound_document
    assert_difference('MovieSoundDocument.count') do
      post :create, :movie_sound_document => { }
    end

    assert_redirected_to movie_sound_document_path(assigns(:movie_sound_document))
  end

  def test_should_show_movie_sound_document
    get :show, :id => movie_sound_documents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movie_sound_documents(:one).id
    assert_response :success
  end

  def test_should_update_movie_sound_document
    put :update, :id => movie_sound_documents(:one).id, :movie_sound_document => { }
    assert_redirected_to movie_sound_document_path(assigns(:movie_sound_document))
  end

  def test_should_destroy_movie_sound_document
    assert_difference('MovieSoundDocument.count', -1) do
      delete :destroy, :id => movie_sound_documents(:one).id
    end

    assert_redirected_to movie_sound_documents_path
  end
end
