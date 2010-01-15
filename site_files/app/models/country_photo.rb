class CountryPhoto < ActiveRecord::Base
  belongs_to :country
  belongs_to :photo
  attr_accessor :association_should_exist
end
