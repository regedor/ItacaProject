class MovieWritenDocument < ActiveRecord::Base
  belongs_to :movie
  belongs_to :writen_document

  attr_accessor :association_should_exist
end
