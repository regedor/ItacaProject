module ABRelation
  #I'm using that when having multiple relation between the same model
  attr_accessor :association_should_exist

  def after_create 
    if SELF.class.all({:conditions =>  {A.to_sym => SELF.send(B), B.to_sym => SELF.send(A)}}).empty?
      SELF.class.new(A.to_sym => SELF.send(B), B.to_sym => SELF.send(A)).save
    end
  end

  def after_destroy
    ab = SELF.class.all(:conditions => { A.to_sym => SELF.send(B), B.to_sym => SELF.send(A)})
    ab.empty? or ab.first.destroy     
  end
end
