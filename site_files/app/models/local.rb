class Local < ActiveRecord::Base
  belongs_to :country

  associated_nn_with 'sound_document', 'locals'
  has_many :sound_document_locals
  has_many :sound_documents, :through => :sound_document_locals
  
  associated_nn_with 'writen_document', 'locals'
  has_many :writen_document_locals
  has_many :writen_documents, :through => :writen_document_locals

  associated_nn_with 'photo', 'locals'
  has_many :photo_locals
  has_many :photos, :through => :photo_locals

  associated_nn_with 'movie', 'locals'
  has_many :movie_locals
  has_many :movies, :through => :movie_locals
end
