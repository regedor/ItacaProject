class MovieSoundDocument < ActiveRecord::Base
  belongs_to :movie
  belongs_to :sound_document

  attr_accessor :association_should_exist
end
