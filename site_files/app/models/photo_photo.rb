class PhotoPhoto < ActiveRecord::Base
  belongs_to :photo
  belongs_to :photo2
  attr_accessor :association_should_exist
end
