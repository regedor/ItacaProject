class WritenDocumentsController < ApplicationController
  # GET /writen_documents
  # GET /writen_documents.xml
  def index
    @writen_documents = ((((WritenDocument.author_filter        params[:author_id]
                                         ).category_filter      params[:category_id]
                                         ).document_type_filter params[:document_type_id]
                                         ).keywords_filter      params[:keywords]
                                         ).all :order => 'lower(title) ASC'
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
