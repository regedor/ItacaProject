class SoundDocumentWritenDocument < ActiveRecord::Base
  belongs_to :sound_document
  belongs_to :writen_document

  attr_accessor :association_should_exist
end
