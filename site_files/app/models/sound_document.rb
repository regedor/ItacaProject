class SoundDocument < ActiveRecord::Base
  belongs_to :category
  belongs_to :author
  belongs_to :director

  associated_nn_with 'movie', 'sound_documents'
  has_many :movie_sound_documents
  has_many :movies, :through => :movie_sound_documents
  
  associated_nn_with 'sound_document', 'writen_documents'
  has_many :sound_document_writen_documents
  has_many :writen_documents, :through => :sound_document_writen_documents

  associated_nn_with 'sound_document', 'photos'
  has_many :sound_document_photos
  has_many :photos, :through => :sound_document_photos

  associated_nn_with 'sound_document', 'locals'
  has_many :sound_document_locals
  has_many :locals, :through => :sound_document_locals

  associated_nn_with 'sound_document', 'prizes'
  has_many :sound_document_prizes
  has_many :prizes, :through => :sound_document_prizes

  associated_nn_with 'sound_document', 'sound_documents'
  has_many :sound_document_sound_documents
  has_many :sound_document2s, :through => :sound_document_sound_documents
end
class SoundDocument2 < SoundDocument
end
