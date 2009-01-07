class MoviePhoto < ActiveRecord::Base
  belongs_to :movie
  belongs_to :photo

  attr_accessor :association_should_exist
end
