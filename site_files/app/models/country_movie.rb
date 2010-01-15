class CountryMovie < ActiveRecord::Base
  belongs_to :country
  belongs_to :movie
  attr_accessor :association_should_exist
end
