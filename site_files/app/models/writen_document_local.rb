class WritenDocumentLocal < ActiveRecord::Base
  belongs_to :writen_document
  belongs_to :local
  attr_accessor :association_should_exist
end
