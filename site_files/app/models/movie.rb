class Movie < ActiveRecord::Base
  #######################
  # Relationships related
  belongs_to :category
  belongs_to :subcategory1, :foreign_key => "subcategory_1_id", :class_name => "Subcategory"
  belongs_to :subcategory2, :foreign_key => "subcategory_2_id", :class_name => "Subcategory"
  belongs_to :subcategory3, :foreign_key => "subcategory_3_id", :class_name => "Subcategory"
  belongs_to :subcategory4, :foreign_key => "subcategory_4_id", :class_name => "Subcategory"
  belongs_to :genre
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
  belongs_to :user

  associated_nn :with =>  nil,               :through => 'movie_movies'
  associated_nn :with => 'sound_documents',  :through => 'movie_sound_documents'
  associated_nn :with => 'writen_documents', :through => 'movie_writen_documents'
  associated_nn :with => 'photos',           :through => 'movie_photos'
  associated_nn :with => 'locals',           :through => 'movie_locals'
  associated_nn :with => 'prizes',           :through => 'movie_prizes'
  associated_nn :with => 'countries',        :through => 'country_movies'

  has_many :movies, :finder_sql =>
      'SELECT movies.* ' +
      'FROM movies INNER JOIN movie_movies ON movies.id = movie_movies.movie2_id ' +
      'WHERE (movie_movies.movie_id = #{id})'

  named_scope :author_filter, lambda { |*args| args.first.blank? ? {} : { :conditions => 
    ["author_id = ? OR author_2_id = ? OR author_3_id = ? OR author_4_id = ? OR author_5_id = ?", 
      args.first,args.first,args.first,args.first,args.first] } 
  }

  named_scope :director_filter, lambda { |*args| args.first.blank? ? {} : { :conditions => 
    ["director_id = ? OR director_2_id = ? OR director_3_id = ? OR director_4_id = ? OR director_5_id = ?", 
      args.first,args.first,args.first,args.first,args.first] } 
  }

  named_scope :genre_filter, lambda { |*args| args.first.blank? ? {} : { :conditions => 
    { :genre_id => args.first }}
  } 

  named_scope :keywords_filter, lambda { |*args| 
    if (args.first.nil? || (tokens=args.first.split).empty? ) 
      {} 
    else
      tokens.map! { |w| "%#{w.downcase}%" } 
      { :conditions => (tokens*14).unshift([
          ( ["(lower(title              ) like ? )"] * tokens.size ).join(" and "),
          ( ["(lower(synopsis           ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(producer           ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(main_event         ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(cultural_context   ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(image_sound        ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(ccdc               ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(reading            ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(exploration        ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(analisis           ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(proposals          ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(production_context ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(comments           ) like ? )"] * tokens.size ).join(" and "), 
          ( ["(lower(distributor        ) like ? )"] * tokens.size ).join(" and ")
        ].join(" or "))
      } 
    end
  } 


  def subcategories
    Subcategory.all :conditions => 
      {:id => [self.subcategory_1_id,self.subcategory_2_id,self.subcategory_3_id,self.subcategory_4_id]}
  end

  def authors
    Author.all :conditions => 
      {:id => [self.author_id,self.author_2_id,self.author_3_id,self.author_4_id,self.author_5_id]}
  end

  def directors
    Director.all :conditions => 
      {:id => [self.director_id,self.director_2_id,self.director_3_id,self.director_4_id,self.director_5_id]}
  end
  
  #######################
  # Instace methods
  def fill_percentage
    unit = 100.0 / self.attributes.size
    percentage = self.attributes.values.map{|v| if v.blank? then 0 else unit end}.sum
    "#{percentage.round}%"
  end

  def director_names
    self.directors.map(&:name).join ", "
  end

end
