class PhotoPrize < ActiveRecord::Base
  belongs_to :photo
  belongs_to :prize 
  attr_accessor :association_should_exist
end
