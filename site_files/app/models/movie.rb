class Movie < ActiveRecord::Base 
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :genre
  belongs_to :author
  belongs_to :director
  belongs_to :user

  associated_nn :with =>  nil,               :through => 'movie_movies'
  associated_nn :with => 'sound_documents',  :through => 'movie_sound_documents'
  associated_nn :with => 'writen_documents', :through => 'movie_writen_documents'
  associated_nn :with => 'photos',           :through => 'movie_photos'
  associated_nn :with => 'locals',           :through => 'movie_locals'
  associated_nn :with => 'prizes',           :through => 'movie_prizes'

  has_many :movies, :finder_sql =>
      'SELECT "movies".* ' +
      'FROM "movies" INNER JOIN movie_movies ON movies.id = movie_movies.movie2_id ' +
      'WHERE (("movie_movies".movie_id = #{id}))'

  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end
end
