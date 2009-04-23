class Local < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  
  associated_nn :with => 'movies',           :through => 'movie_locals'
  associated_nn :with => 'sound_documents',   :through => 'sound_document_locals'
  associated_nn :with => 'writen_documents', :through => 'writen_document_locals'
  associated_nn :with => 'photos',           :through => 'photo_locals'
  associated_nn :with =>  nil,               :through => 'local_locals'
  
  has_many :locals, :finder_sql =>
   'SELECT locals.* ' +
   'FROM locals INNER JOIN local_locals ON locals.id = local_locals.local2_id ' +
   'WHERE ((local_locals.local_id = #{id}))'

  def countryname
    self.country.name
  end
end
