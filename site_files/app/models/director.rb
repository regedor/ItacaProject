class Director < ActiveRecord::Base
  has_many :movies
  has_many :sound_documents
end
