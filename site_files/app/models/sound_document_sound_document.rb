class SoundDocumentSoundDocument < ActiveRecord::Base
  belongs_to :sound_document
  belongs_to :sound_document2
  attr_accessor :association_should_exist
end
