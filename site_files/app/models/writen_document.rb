class WritenDocument < ActiveRecord::Base
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
  belongs_to :document_type
  belongs_to :user

  uploadify  :dir => 'public/assets/pdfs'

  associated_nn :with => 'movies',           :through => 'movie_writen_documents'
  associated_nn :with => 'sound_documents',  :through => 'sound_document_writen_documents'
  associated_nn :with =>  nil,               :through => 'writen_document_writen_documents'
  associated_nn :with => 'photos',           :through => 'writen_document_photos'
  associated_nn :with => 'locals',           :through => 'writen_document_locals'
  associated_nn :with => 'prizes',           :through => 'writen_document_prizes'
  associated_nn :with => 'countries',        :through => 'country_writen_documents'

  has_many :writen_documents, :finder_sql =>
    'SELECT writen_documents.* ' +
    'FROM writen_documents INNER JOIN writen_document_writen_documents' + 
    '  ON writen_documents.id = writen_document_writen_documents.writen_document2_id ' +
    'WHERE (writen_document_writen_documents.writen_document_id = #{id})'

  def pdf_uploaded_data=(data)
    self.uploaded_data = data
  end
  
  def pdf_already_uploaded_data
    self.already_uploaded_data
  end
  
  def pdf_already_uploaded_data=(data)
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


  #######################
  # Instace methods
  def fill_percentage
    unit = 100.0 / self.attributes.size
    percentage = self.attributes.values.map{|v| if v.blank? then 0 else unit end}.sum
    "#{percentage.round}%"
  end

  def author_names
    self.authors.map(&:name).join ", "
  end

end
