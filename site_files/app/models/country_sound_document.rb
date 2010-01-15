class CountrySoundDocument < ActiveRecord::Base
  belongs_to :country
  belongs_to :sound_document
  attr_accessor :association_should_exist
end
