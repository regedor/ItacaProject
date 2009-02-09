class Photo < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :author
  belongs_to :genre
  belongs_to :user

  associated_nn :to => 'movies',           :through => 'movie_photos'
  associated_nn :to => 'sound_documents',  :through => 'sound_document_photos'
  associated_nn :to => 'writen_documents', :through => 'writen_document_photos'
  associated_nn :to =>  nil,               :through => 'photo_photos'
  associated_nn :to => 'locals',           :through => 'photo_locals'
  associated_nn :to => 'prizes',           :through => 'photo_prizes'

  has_many :photo_photos, :finder_sql =>
    'SELECT "photos".* ' +
    'FROM "photos" INNER JOIN photo_photos' + 
    '  ON photos.id = photo_photos.photo2_id ' +
    'WHERE (("photo_photos".photo_id = #{id}))'

  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end
end
