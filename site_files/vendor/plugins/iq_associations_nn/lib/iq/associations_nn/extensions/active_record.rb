module IQ::AssociationsNn::Extensions::ActiveRecord
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def associated_nn(options)
      #options = args.last.is_a?(Hash) ? args.pop : {}
      #raise "Too many parameters" unless args.size == 2
      associations_name = options[:through]  
      resources2_name   = options[:to]

      if resources2_name
        has_many resources2_name.to_sym, :through => associations_name.to_sym
      end
      has_many associations_name.to_sym

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
