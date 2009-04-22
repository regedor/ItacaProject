class Author < ActiveRecord::Base
  has_many :photos
  belongs_to :user

  has_many :movies, :finder_sql =>
      'SELECT movies.* ' +
      'FROM movies ' +
      'WHERE movies.author_id = #{id} OR movies.author_2_id = #{id} ' +
      'OR movies.author_3_id = #{id} OR movies.author_4_id = #{id} OR movies.author_5_id = #{id}'

  has_many :sound_documents, :finder_sql =>
      'SELECT sound_documents.* ' +
      'FROM sound_documents ' +
      'WHERE sound_documents.author_id = #{id} OR sound_documents.author_2_id = #{id} ' +
      'OR sound_documents.author_3_id = #{id} OR sound_documents.author_4_id = #{id} ' +
      'OR sound_documents.author_5_id = #{id}'

  has_many :writen_documents, :finder_sql =>
      'SELECT writen_documents.* ' +
      'FROM writen_documents ' +
      'WHERE writen_documents.author_id = #{id} OR writen_documents.author_2_id = #{id} ' +
      'OR writen_documents.author_3_id = #{id} OR writen_documents.author_4_id = #{id} ' +
      'OR writen_documents.author_5_id = #{id}'

  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end
end
