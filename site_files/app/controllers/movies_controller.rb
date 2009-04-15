class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    @movies = Movie.all :order => 'title ASC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies  }
      format.pdf  { render :layout => false }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
      format.pdf  { 
       #prawnto :filename => "#{@movie.title.downcase.gsub /( |[^a-z,0-9])/, "_"}.pdf"
        prawnto :filename => "#{@movie.title.downcase.gsub /( )/, "_"}.pdf"
        render :layout => false 
      }
    end
  end

end
