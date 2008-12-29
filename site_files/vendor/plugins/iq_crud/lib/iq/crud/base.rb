# Current resource(s) methods and helpers:
# * +current_member+
# * +current_collection+
# 
# URL methods and helpers:
# * +member_path+
# * +new_member_path+
# * +edit_member_path+
# * +delete_member_path+
# * +collection_path+
# 
# Utility methods and helpers based on controller/resource name
# * +resource_finder+
# * +resource_plural+
# * +resource_singular+
# 
module IQ::Crud::Base
  def self.included(base) # :nodoc:
    base.helper_method  :current_member, :current_collection,
                        :resource_finder, :resource_class, :resource_singular, :resource_plural,
                        :collection_path, :member_path, :new_member_path, :edit_member_path, :delete_member_path
    base.write_inheritable_attribute(:crudify_config_procs, [])
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def crudify_config_procs
      read_inheritable_attribute(:crudify_config_procs)
    end
    
    # Used to register procs that will be run when the crudify macro is called.
    def crudify_config(&block)
      raise ArgumentError, 'Block must be supplied' unless block_given?
      crudify_config_procs << block
    end
  end

  protected

  # Returns the current resource collection.
  def current_collection() instance_variable_get("@#{resource_plural}") end
  
  # Returns the current resource instance.
  def current_member() instance_variable_get("@#{resource_singular}") end

  # Returns the resource class determined by the <tt>:finder</tt> option of
  # +crudify+. When no <tt>:finder</tt> option supplied, the first argument
  # passed to +crudify+ or the +controller_name+ are used respectively to
  # determine resource class.
  def resource_finder
    case finder = crudify_options[:finder]
      when Symbol : send(finder)
      when Proc   : instance_exec(&finder)
      else self.class.read_inheritable_attribute(:resource_class) || self.class.controller_name.classify.constantize
    end
  end

  # Returns the +resource_finder+ when it is a class or the +resource_finder.name+
  # classified respectively.
  def resource_class
    resource_finder.is_a?(Class) ? resource_finder : resource_finder.name.classify.constantize
  end

  # Returns the plural underscored resource string determined by +controller_name+.
  def resource_plural() self.class.read_inheritable_attribute(:resource_plural) end

  # Returns the singular underscored resource string determined by +controller_name+.
  def resource_singular() self.class.read_inheritable_attribute(:resource_singular) end
  
  # Returns path to 'index' action preserving current namespace
  def collection_path
    url_for(
      :controller => controller_path, 
      :action => 'index',
      :only_path => true,
      :use_route => controller_path.tr('/', '_')
    )
  end
  
  # Returns path to 'show' action preserving current namespace
  def member_path(member)
    polymorphic_path(controller_namespace.empty? ? member : controller_namespace << member)
  end
  
  # Returns path to 'new' action preserving current namespace
  def new_member_path
    new_polymorphic_path(controller_namespace.empty? ? resource_class : controller_namespace << resource_class)
  end
  
  # Returns path to 'edit' action preserving current namespace
  def edit_member_path(member)
    edit_polymorphic_path(controller_namespace.empty? ? member : controller_namespace << member)
  end
  
  # Returns path to 'delete' action preserving current namespace
  def delete_member_path(member)
    polymorphic_url(
      controller_namespace.empty? ? member : controller_namespace << member,
      :action => 'delete', :routing_type => :path
    )
  end
  
  private

  def find_collection
    case callback = crudify_options[:collection]
      when Symbol : resource_finder.send(callback) 
      when Proc   : instance_exec(resource_finder, &callback)
      else resource_finder.find(:all)
    end
  end

  def find_member
    case callback = crudify_options[:member]
      when Symbol : resource_finder.send(callback, params[:id]) 
      when Proc   : instance_exec(resource_finder, &callback)
      else resource_finder.find(params[:id])
    end
  end
  
  def build_member(attributes = nil)
    args = attributes.nil? ? [] : [attributes]
    case callback = crudify_options[:build]
      when Symbol : resource_finder.send(callback) 
      when Proc   : instance_exec(resource_finder, &callback)
      else resource_finder.is_a?(Class) ? resource_finder.new(*args) : resource_finder.build(*args)
    end
  end

  # Calls respond block for given action based on registered +response_for+ block.
  def response_for(action)
    raise ArgumentError, 'Argument must be a Symbol' unless action.is_a? Symbol
    return unless responses = self.class.read_inheritable_attribute(:crudify_responses)[action]
    
    respond_to do |format|
      responses.each { |name, proc| format.send(name, &lambda { instance_eval &proc }) }
    end
  end  

  def crudify_options
    self.class.read_inheritable_attribute(:crudify_options)
  end
  
  def controller_namespace
    (@controller_namespace ||= controller_path.split('/')[0..-2].freeze).dup
  end
end