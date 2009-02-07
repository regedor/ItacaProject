class MusicGenre < ActiveRecord::Base
  has_many :sound_documents
end
