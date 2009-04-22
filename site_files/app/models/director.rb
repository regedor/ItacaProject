class Director < ActiveRecord::Base
  belongs_to :user
  has_many :movies, :finder_sql =>
      'SELECT movies.* ' +
      'FROM movies ' +
      'WHERE movies.director_id = #{id} OR movies.director_2_id = #{id} ' +
      'OR movies.director_3_id = #{id} OR movies.author_4_id = #{id} OR movies.author_5_id = #{id}'

  has_many :sound_documents, :finder_sql =>
      'SELECT sound_documents.* ' +
      'FROM sound_documents ' +
      'WHERE sound_documents.director_id = #{id} OR sound_documents.author_2_id = #{id} ' +
      'OR sound_documents.director_3_id = #{id} OR sound_documents.author_4_id = #{id} ' +
      'OR sound_documents.director_5_id = #{id}'
end
