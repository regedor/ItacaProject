class Local < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  
  associated_nn :to => 'movies',           :through => 'movie_locals'
  associated_nn :to => 'sound_document',   :through => 'sound_document_locals'
  associated_nn :to => 'writen_documents', :through => 'writen_document_locals'
  associated_nn :to => 'photos',           :through => 'photo_locals'
  associated_nn :to =>  nil,               :through => 'local_locals'
  
  has_many :sound_documents, :finder_sql =>
    'SELECT "sound_documents".* ' +
    'FROM "sound_documents" INNER JOIN sound_document_sound_documents' + 
    '  ON sound_documents.id = sound_document_sound_documents.sound_document2_id ' +
    'WHERE (("sound_document_sound_documents".sound_document_id = #{id}))'
  
  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end
end
