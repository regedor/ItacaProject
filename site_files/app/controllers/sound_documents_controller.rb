class SoundDocumentsController < ApplicationController
  # GET /sound_documents
  # GET /sound_documents.xml
  def index
    @sound_documents = ((((SoundDocument.author_filter     params[:author_id]
                                       ).director_filter   params[:director_id]
                                       ).music_genre_filter params[:music_genre_id]
                                       ).keywords_filter   params[:keywords]
                                       ).all :order => 'lower(title) ASC'
  end

  # GET /sound_documents/1
  # GET /sound_documents/1.xml
  def show
    @sound_document = SoundDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sound_document }
      format.pdf  { 
       #prawnto :filename => "#{@sound_document.title.downcase.gsub /( |[^a-z,0-9])/, "_"}.pdf"
        prawnto :filename => "#{@sound_document.title.downcase.gsub /( )/, "_"}.pdf"
        render :layout => false 
      }
    end
  end

end
