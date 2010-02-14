class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    @movies = ((((Movie.author_filter   params[:author_id]
                      ).director_filter params[:director_id]
                      ).genre_filter    params[:genre_id]
                      ).keywords_filter params[:keywords]
                      ).all :order => 'lower(title) ASC'
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf  { 
       #prawnto :filename => "#{@movie.title.downcase.gsub /( |[^a-z,0-9])/, "_"}.pdf"
        prawnto :filename => "#{@movie.title.downcase.gsub /( )/, "_"}.pdf"
        render :layout => false 
      }
    end
  end

end
