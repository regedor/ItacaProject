class Movie < ActiveRecord::Base 
  belongs_to :category
  belongs_to :genre
  belongs_to :author
  belongs_to :director

  associated_nn_with 'movie', 'sound_documents'
  has_many :movie_sound_documents
  has_many :sound_documents, :through => :movie_sound_documents
  
  associated_nn_with 'movie', 'writen_documents'
  has_many :movie_writen_documents
  has_many :writen_documents, :through => :movie_writen_documents

  associated_nn_with 'movie', 'photos'
  has_many :movie_photos
  has_many :photos, :through => :movie_photos

  associated_nn_with 'movie', 'locals'
  has_many :movie_locals
  has_many :locals, :through => :movie_locals

  associated_nn_with 'movie', 'prizes'
  has_many :movie_prizes
  has_many :prizes, :through => :movie_prizes

  associated_nn_with 'movie', 'movies'
  has_many :movie_movies
  has_many :movie2s, :through => :movie_movies
end

class Movie2 < Movie
end	
