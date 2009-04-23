class Photo < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :author1, :foreign_key => "author_id",   :class_name => "Author"
  belongs_to :author2, :foreign_key => "author_2_id", :class_name => "Author"
  belongs_to :author3, :foreign_key => "author_3_id", :class_name => "Author"
  belongs_to :author4, :foreign_key => "author_4_id", :class_name => "Author"
  belongs_to :author5, :foreign_key => "author_5_id", :class_name => "Author"
  belongs_to :genre
  belongs_to :user

  uploadify :dir => 'public/assets/photos'
  process(          :format => 'jpg', :basename => 'original')    { |img| img.fit_to! 800, 800 }
  process(:preview, :format => 'jpg', :basename => :version_name) { |img| img.fit_to! 64, 64 }

  associated_nn :with => 'movies',           :through => 'movie_photos'
  associated_nn :with => 'sound_documents',  :through => 'sound_document_photos'
  associated_nn :with => 'writen_documents', :through => 'writen_document_photos'
  associated_nn :with =>  nil,               :through => 'photo_photos'
  associated_nn :with => 'locals',           :through => 'photo_locals'
  associated_nn :with => 'prizes',           :through => 'photo_prizes'



  has_many :photo_photos, :finder_sql =>
    'SELECT photos.* ' +
    'FROM photos INNER JOIN photo_photos' + 
    '  ON photos.id = photo_photos.photo2_id ' +
    'WHERE (photo_photos.photo_id = #{id})'

  def photo_uploaded_data=(data)
    self.uploaded_data = data
  end
  
  def photo_already_uploaded_data
    self.already_uploaded_data
  end
  
  def photo_already_uploaded_data=(data)
    self.already_uploaded_data = data
  end

  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end
  def authors
    Author.all :conditions => 
      {:id => [self.author_id,self.author_2_id,self.author_3_id,self.author_4_id,self.author_5_id]}
  end
end
