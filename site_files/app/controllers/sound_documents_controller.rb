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

  # GET /sound_documents/new
  # GET /sound_documents/new.xml
  def new
    @sound_document = SoundDocument.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sound_document }
    end
  end

  # GET /sound_documents/1/edit
  def edit
    @sound_document = SoundDocument.find(params[:id])
  end

  # POST /sound_documents
  # POST /sound_documents.xml
  def create
    @sound_document = SoundDocument.new(params[:sound_document])

    respond_to do |format|
      if @sound_document.save
        flash[:notice] = 'SoundDocument was successfully created.'
        format.html { redirect_to(@sound_document) }
        format.xml  { render :xml => @sound_document, :status => :created, :location => @sound_document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sound_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sound_documents/1
  # PUT /sound_documents/1.xml
  def update
    @sound_document = SoundDocument.find(params[:id])

    respond_to do |format|
      if @sound_document.update_attributes(params[:sound_document])
        flash[:notice] = 'SoundDocument was successfully updated.'
        format.html { redirect_to(@sound_document) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sound_document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sound_documents/1
  # DELETE /sound_documents/1.xml
  def destroy
    @sound_document = SoundDocument.find(params[:id])
    @sound_document.destroy

    respond_to do |format|
      format.html { redirect_to(sound_documents_url) }
      format.xml  { head :ok }
    end
  end
end
