class Director < ActiveRecord::Base
  has_many :movies
  has_many :sound_documents
  belongs_to :user
end
