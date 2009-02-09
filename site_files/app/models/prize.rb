class Prize < ActiveRecord::Base
  belongs_to :user
  
  associated_nn :to => 'movies',           :through => 'movie_prizes'
  associated_nn :to => 'sound_document',   :through => 'sound_document_prizes'
  associated_nn :to => 'writen_documents', :through => 'writen_document_prizes'
  associated_nn :to => 'photos',           :through => 'photo_prizes'
end
