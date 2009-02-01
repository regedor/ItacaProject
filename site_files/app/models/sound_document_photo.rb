class SoundDocumentPhoto < ActiveRecord::Base
  belongs_to :sound_document
  belongs_to :photo
  attr_accessor :association_should_exist
end
