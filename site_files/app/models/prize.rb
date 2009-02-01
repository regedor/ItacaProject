class Prize < ActiveRecord::Base
  associated_nn_with 'sound_document', 'prizes'
  has_many :sound_document_prizes
  has_many :sound_documents, :through => :sound_document_prizes
  
  associated_nn_with 'writen_document', 'prizes'
  has_many :writen_document_prizes
  has_many :writen_documents, :through => :writen_document_prizes

  associated_nn_with 'photo', 'prizes'
  has_many :photo_prizes
  has_many :photos, :through => :photo_prizes

  associated_nn_with 'movie', 'prizes'
  has_many :movie_prizes
  has_many :movies, :through => :movie_prizes
end
