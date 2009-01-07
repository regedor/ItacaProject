class MoviePrize < ActiveRecord::Base
  belongs_to :movie
  belongs_to :prize

  attr_accessor :association_should_exist
end
