class WritenDocument < ActiveRecord::Base
  belongs_to :category
  belongs_to :author
  belongs_to :document_type

  associated_nn_with 'sound_document', 'writen_documents'
  has_many :sound_document_writen_documents
  has_many :sound_documents, :through => :sound_document_writen_documents
  
  associated_nn_with 'movie', 'writen_documents'
  has_many :movie_writen_documents
  has_many :movies, :through => :movie_writen_documents

  associated_nn_with 'writen_document', 'photos'
  has_many :writen_document_photos
  has_many :photos, :through => :writen_document_photos

  associated_nn_with 'writen_document', 'locals'
  has_many :writen_document_locals
  has_many :locals, :through => :writen_document_locals

  associated_nn_with 'writen_document', 'prizes'
  has_many :writen_document_prizes
  has_many :prizes, :through => :writen_document_prizes

  associated_nn_with 'writen_document', 'writen_documents'
  has_many :writen_document_writen_documents
  has_many :writen_document2s, :through => :writen_document_writen_documents
end
class WritenDocument2 < WritenDocument
end	
