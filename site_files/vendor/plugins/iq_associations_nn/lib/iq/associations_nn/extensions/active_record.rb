module IQ::AssociationsNn::Extensions::ActiveRecord
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def associated_nn_with(*args)
      #options = args.last.is_a?(Hash) ? args.pop : {}
      raise "Too many parameters" unless args.size == 2
      resource1_name   = args[0]
      resource2_name   = args[1]
      associations_name = "#{resource1_name}_#{resource2_name}".pluralize
      
      
      after_update ("save_" + associations_name).to_sym

      define_method "new_" + associations_name + "_attributes=" do |associations|
        IQ::AssociationsNn.new_associations_attributes_setter associations, self, associations_name
      end

      define_method "existing_" + associations_name + "_attributes=" do |associations|
        IQ::AssociationsNn.existing_associations_attributes_setter associations, self, associations_name
      end

      define_method "save_" + associations_name do
        IQ::AssociationsNn.save_associations self, associations_name
      end
      
    end
 
  end
  
end
