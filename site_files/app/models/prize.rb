class Prize < ActiveRecord::Base
  belongs_to :user
  
  associated_nn :with => 'movies',           :through => 'movie_prizes'
  associated_nn :with => 'sound_documents',   :through => 'sound_document_prizes'
  associated_nn :with => 'writen_documents', :through => 'writen_document_prizes'
  associated_nn :with => 'photos',           :through => 'photo_prizes'


  def description_for(item)
    case item.class.to_s
      when  "Movie"
        MoviePrize.last({:conditions => {:movie_id => item.id, :prize_id => self.id}}).description
      when "SoundDocument"
        SoundDocumentPrize.last({:conditions => {:sound_document_id => item.id, :prize_id => self.id}}).description
    end
  end

end
