class PrizeLocal < ActiveRecord::Base
  belongs_to :prize 
  belongs_to :local
  attr_accessor :association_should_exist
end
