class SoundDocument < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :author
  belongs_to :director
  belongs_to :music_genre
  belongs_to :user

  associated_nn :to => 'movies',           :through => 'movie_sound_documents'
  associated_nn :to =>  nil,               :through => 'sound_document_sound_documents'
  associated_nn :to => 'writen_documents', :through => 'sound_document_writen_documents'
  associated_nn :to => 'photos',           :through => 'sound_document_photos'
  associated_nn :to => 'locals',           :through => 'sound_document_locals'
  associated_nn :to => 'prizes',           :through => 'sound_document_prizes'

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
