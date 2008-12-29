module IQ # :nodoc:
  module AssociationsNn # :nodoc:
    
    module Extensions # :nodoc:
      autoload(:ActiveRecord,     File.join(File.dirname(__FILE__), 'associations_nn/extensions/active_record'))
      autoload(:ActionController, File.join(File.dirname(__FILE__), 'associations_nn', 'extensions', 'action_controller'))
    end
    
    module Helper # :nodoc:
      autoload :JsNnAssociation,   File.join(File.dirname(__FILE__), 'associations_nn/helper/js_nn_associations')
    end
    
    def self.new_associations_attributes_setter (associations, resource1_member, associations_string)
      associations.each do |key,attributes|
        (resource1_member.send associations_string).build(attributes) if attributes[:association_should_exist] == "1"
      end
    end

    def self.existing_associations_attributes_setter (associations, resource1_member, associations_string)
      (resource1_member.send associations_string).reject(&:new_record?).each do |association|
        attributes = associations[association.id.to_s]
        if attributes && attributes.delete(:association_should_exist) == "1"
          association.attributes = attributes
        else
          (resource1_member.send associations_string).delete(association)#directo
        end
      end
    end
    
    def self.save_associations(resource1_member, associations_string)
      (resource1_member.send associations_string).each do |association|
        association.save(false)
      end
    end
    
  end
end



module ActionView # :nodoc:
  class Base # :nodoc:
      include IQ::AssociationsNn::Helper::JsNnAssociation
  end
  module Helpers
    class JsNnAssociation
      include IQ::AssociationsNn::Helper::JsNnAssociation
    end
  end
end