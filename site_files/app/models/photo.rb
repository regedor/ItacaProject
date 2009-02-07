class Photo < ActiveRecord::Base
  belongs_to :category
  belongs_to :genre
  belongs_to :author
  belongs_to :director

  associated_nn_with 'sound_document', 'photos'
  has_many :sound_document_photos
  has_many :sound_documents, :through => :sound_document_photos
  
  associated_nn_with 'writen_document', 'photos'
  has_many :writen_document_photos
  has_many :writen_documents, :through => :writen_document_photos

  associated_nn_with 'movie', 'photos'
  has_many :movie_photos
  has_many :movies, :through => :movie_photos

  associated_nn_with 'photo', 'locals'
  has_many :photo_locals
  has_many :locals, :through => :photo_locals

  associated_nn_with 'photo', 'prizes'
  has_many :photo_prizes
  has_many :prizes, :through => :photo_prizes

  associated_nn_with 'photo', 'photos'
  has_many :photo_photos
  has_many :photos, :finder_sql =>
      'SELECT "photos".* ' +
      'FROM "photos" INNER JOIN photo_photos ON photo.id = photo_photos.photo2_id ' +
      'WHERE (("photo_photos".photo_id = #{id}))'
end
