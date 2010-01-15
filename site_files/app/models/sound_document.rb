class SoundDocument < ActiveRecord::Base
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
  belongs_to :director1, :foreign_key => "director_id",   :class_name => "Author"
  belongs_to :director2, :foreign_key => "director_2_id", :class_name => "Author"
  belongs_to :director3, :foreign_key => "director_3_id", :class_name => "Author"
  belongs_to :director4, :foreign_key => "director_4_id", :class_name => "Author"
  belongs_to :director5, :foreign_key => "director_5_id", :class_name => "Author"
  belongs_to :music_genre
  belongs_to :user

  associated_nn :with => 'movies',           :through => 'movie_sound_documents'
  associated_nn :with =>  nil,               :through => 'sound_document_sound_documents'
  associated_nn :with => 'writen_documents', :through => 'sound_document_writen_documents'
  associated_nn :with => 'photos',           :through => 'sound_document_photos'
  associated_nn :with => 'locals',           :through => 'sound_document_locals'
  associated_nn :with => 'prizes',           :through => 'sound_document_prizes'
  associated_nn :with => 'countries',  :through => 'country_sound_documents'

  has_many :sound_documents, :finder_sql =>
    'SELECT sound_documents.* ' +
    'FROM sound_documents INNER JOIN sound_document_sound_documents' + 
    '  ON sound_documents.id = sound_document_sound_documents.sound_document2_id ' +
    'WHERE ((sound_document_sound_documents.sound_document_id = #{id}))'
  
  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end

  def authors
    Author.all :conditions => 
      {:id => [self.author_id,self.author_2_id,self.author_3_id,self.author_4_id,self.author_5_id]}
  end

  def directors
    Author.all :conditions => 
      {:id => [self.director_id,self.director_2_id,self.director_3_id,self.director_4_id,self.director_5_id]}
  end


  #######################
  # Instace methods
  def fill_percentage
    unit = 100.0 / self.attributes.size
    percentage = self.attributes.values.map{|v| if v.blank? then 0 else unit end}.sum
    "#{percentage.round}%"
  end

end
