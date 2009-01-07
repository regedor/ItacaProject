class MovieLocal < ActiveRecord::Base
  belongs_to :movie
  belongs_to :local
end
