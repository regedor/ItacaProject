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

  # GET /writen_documents/new
  # GET /writen_documents/new.xml
  def new
    @writen_document = WritenDocument.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @writen_document }
    end
  end

  # GET /writen_documents/1/edit
  def edit
    @writen_document = WritenDocument.find(params[:id])
  end

  # POST /writen_documents
  # POST /writen_documents.xml
  def create
    @writen_document = WritenDocument.new(params[:writen_document])

    respond_to do |format|
      if @writen_document.save
        flash[:notice] = 'WritenDocument was successfully created.'
        format.html { redirect_to(@writen_document) }
        format.xml  { render :xml => @writen_document, :status => :created, :location => @writen_document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @writen_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /writen_documents/1
  # PUT /writen_documents/1.xml
  def update
    @writen_document = WritenDocument.find(params[:id])

    respond_to do |format|
      if @writen_document.update_attributes(params[:writen_document])
        flash[:notice] = 'WritenDocument was successfully updated.'
        format.html { redirect_to(@writen_document) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @writen_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /writen_documents/1
  # DELETE /writen_documents/1.xml
  def destroy
    @writen_document = WritenDocument.find(params[:id])
    @writen_document.destroy

    respond_to do |format|
      format.html { redirect_to(writen_documents_url) }
      format.xml  { head :ok }
    end
  end
end
