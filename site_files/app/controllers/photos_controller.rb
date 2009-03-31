class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  def index
    @photos = Photo.find_all_by_base_version_id nil 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

end
