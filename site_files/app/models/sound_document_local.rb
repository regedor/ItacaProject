class SoundDocumentLocal < ActiveRecord::Base
  belongs_to :sound_document
  belongs_to :local
  attr_accessor :association_should_exist
end
