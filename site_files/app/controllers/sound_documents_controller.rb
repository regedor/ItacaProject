class SoundDocumentsController < ApplicationController
  # GET /sound_documents
  # GET /sound_documents.xml
  def index
    @sound_documents = SoundDocument.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sound_documents }
    end
  end

  # GET /sound_documents/1
  # GET /sound_documents/1.xml
  def show
    @sound_document = SoundDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sound_document }
    end
  end

end
