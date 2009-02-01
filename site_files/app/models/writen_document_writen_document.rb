class WritenDocumentWritenDocument < ActiveRecord::Base
  belongs_to :writen_document
  belongs_to :writen_document2
  attr_accessor :association_should_exist
end
