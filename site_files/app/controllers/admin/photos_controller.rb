class Admin::PhotosController < Admin::BaseController
  crudify

  def index
    @photos = Photo.find_all_by_base_version_id nil 
    response_for :index
  end
end
