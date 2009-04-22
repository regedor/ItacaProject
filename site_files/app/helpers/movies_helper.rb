module MoviesHelper
  def directors_names(movie)
    movie.directors.map(&:name).join ", "
  end
end
