class WritenDocumentsController < ApplicationController
  # GET /writen_documents
  # GET /writen_documents.xml
  def index
    @writen_documents = WritenDocument.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @writen_documents }
    end
  end

  # GET /writen_documents/1
  # GET /writen_documents/1.xml
  def show
    @writen_document = WritenDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @writen_document }
    end
  end

end
