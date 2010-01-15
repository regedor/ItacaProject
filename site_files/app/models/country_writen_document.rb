class CountryWritenDocument < ActiveRecord::Base
  belongs_to :country
  belongs_to :writen_document
  attr_accessor :association_should_exist
end
