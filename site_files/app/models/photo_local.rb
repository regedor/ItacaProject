class PhotoLocal < ActiveRecord::Base
  belongs_to :photo
  belongs_to :local
  attr_accessor :association_should_exist
end
