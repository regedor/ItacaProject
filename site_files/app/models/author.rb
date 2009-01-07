class Author < ActiveRecord::Base
  has_many :movies
  has_many :sound_documents
  has_many :writen_documents
  has_many :photos
end
