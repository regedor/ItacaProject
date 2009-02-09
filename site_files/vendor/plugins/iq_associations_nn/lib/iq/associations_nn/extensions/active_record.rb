module IQ::AssociationsNn::Extensions::ActiveRecord
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def associated_nn(options)
      raise "Should recieve one Hash." unless options.is_a?(Hash)
      raise "Couldn't find :through param." unless options[:through]
      associations_name = options[:through]
      resources2_name   = options[:with]
      
      has_many resources2_name.to_sym, :through => associations_name.to_sym if resources2_name
      
      has_many associations_name.to_sym, :dependent => :destroy
      
      after_update ("save_" + associations_name.to_s).to_sym

      define_method "new_" + associations_name.to_s + "_attributes=" do |associations|
        IQ::AssociationsNn.new_associations_attributes_setter associations, self, associations_name
      end

      define_method "existing_" + associations_name.to_s + "_attributes=" do |associations|
        IQ::AssociationsNn.existing_associations_attributes_setter associations, self, associations_name
      end

      define_method "save_" + associations_name.to_s do
        IQ::AssociationsNn.save_associations self, associations_name
      end
      
    end
 
  end
  
end
