class WritenDocumentPrize < ActiveRecord::Base
  belongs_to :writen_document
  belongs_to :prize
  attr_accessor :association_should_exist
end
