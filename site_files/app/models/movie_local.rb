class MovieLocal < ActiveRecord::Base
  belongs_to :movie
  belongs_to :local
  attr_accessor :association_should_exist
end
