class WritenDocument < ActiveRecord::Base
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :author
  belongs_to :document_type
  belongs_to :user

  uploadify  :dir => 'public/assets/pdfs'

  associated_nn :to => 'movies',           :through => 'movie_writen_documents'
  associated_nn :to => 'sound_documents',  :through => 'sound_document_writen_documents'
  associated_nn :to =>  nil,               :through => 'writen_document_writen_documents'
  associated_nn :to => 'photos',           :through => 'writen_document_photos'
  associated_nn :to => 'locals',           :through => 'writen_document_locals'
  associated_nn :to => 'prizes',           :through => 'writen_document_prizes'

  has_many :writen_documents, :finder_sql =>
    'SELECT "writen_documents".* ' +
    'FROM "writen_documents" INNER JOIN writen_document_writen_documents' + 
    '  ON writen_document.id = writen_document_writen_documents.writen_document2_id ' +
    'WHERE (("writen_document_writen_documents".writen_document_id = #{id}))'

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
end
