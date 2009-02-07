class MovieMovie < ActiveRecord::Base
  A = 'movie_id'
  B = 'movie2_id'
  belongs_to :movie
  attr_accessor :association_should_exist

  def after_create 
    if self.class.all({:conditions => {A.to_sym => self.send(B), B.to_sym => self.send(A)}}).empty?
      self.class.new(A.to_sym => self.send(B), B.to_sym => self.send(A)).save
    end
  end

  def after_destroy
    ab = self.class.all(:conditions => {A.to_sym => self.send(B), B.to_sym => self.send(A)})
    ab.empty? or ab.first.destroy 
  end

end
