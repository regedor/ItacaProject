class MovieMovie < ActiveRecord::Base
  belongs_to :movie
  belongs_to :movie2
  attr_accessor :association_should_exist
end
