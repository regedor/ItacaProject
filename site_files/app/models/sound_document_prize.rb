class SoundDocumentPrize < ActiveRecord::Base
  belongs_to :sound_document
  belongs_to :prize
  attr_accessor :association_should_exist
end
