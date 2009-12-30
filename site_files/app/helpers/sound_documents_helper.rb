module SoundDocumentsHelper
  def authors_names(movie)
    movie.authors.map(&:name).join ", "
  end
end
