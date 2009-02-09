class LocalLocal < ActiveRecord::Base
  A = 'local_id'
  B = 'local2_id'
  belongs_to :local
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
