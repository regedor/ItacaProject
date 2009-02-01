class WritenDocumentPhoto < ActiveRecord::Base
  belongs_to :writen_document
  belongs_to :photo
  attr_accessor :association_should_exist
end
