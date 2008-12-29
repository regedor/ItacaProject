module IQ::Crud::Extensions::ActionController # :nodoc:
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  # TODO: 
  # * :params_key option
  # More examples

  module ClassMethods
    # Defines basic CRUD actions which can then be overridden as needed.
    # 
    # Options:
    # * <tt>:finder</tt> - a symbol or Proc defining a callback for the object
    #   that +find+/+build+ gets called on (usually ActiveRecord collection).
    #   The result will get yielded in <tt>:collection</tt>, <tt>:member</tt>
    #   and <tt>:build</tt> callbacks if a Proc is supplied for these.
    # 
    # * <tt>:collection</tt> - when a Symbol is supplied, the method of that
    #   name is called on the <tt>:finder</tt> or +resource_class+ respectively.
    #   When a Proc is supplied, it is called with the <tt>:finder</tt> or
    #   +resource_class+ as the block parameter, the result of the Proc should
    #   be a collection of resource instances.
    # 
    # * <tt>:member</tt> - when a Symbol is supplied, the method of that name 
    #   is called on the <tt>:finder</tt> or +resource_class+ respectively
    #   giving the result of <tt>params[:id]</tt> as the first argument. The
    #   method is expected to return a resource instance.
    #   When a Proc is supplied, it is called with the <tt>:finder</tt> or
    #   +resource_class+ as the block parameter, the result of the Proc should
    #   be a resource instance.
    # 
    # * <tt>:build</tt> - when a Symbol is supplied, the method of that
    #   name is called on the <tt>:finder</tt> or +resource_class+ respectively
    #   and is expected to return a resource instance.
    #   When a Proc is supplied, it is called with the <tt>:finder</tt> or
    #   +resource_class+ as the block parameter, the result of the Proc should
    #   be a resource instance.
    # 
    # * <tt>:exclude</tt> - an array of crud operations to exclude from
    #   the defaults.
    # 
    # * <tt>:only</tt> - an array of crud operations to include. Default value:
    #   <tt>[:index, :show, :new, :create, :edit, :update, :delete, :destroy]</tt>.
    # 
    # * <tt>:reorder</tt> - if set to true, a <tt>reorder</tt> method will be
    #   added and +current_collection+ will return results ordered by the
    #   +position+ column.
    # 
    # Examples:
    #   class Post < ActiveRecord::Base
    #     crudify :collection => Proc.new { |finder| finder.find_most_recent(10) }
    #   end
    # 
    #   class Post < ActiveRecord::Base
    #     crudify :collection => :find_most_recent # useful if no args are needed
    #   end
    # 
    # Crud actions defined by default:
    #     
    #    CRUD         | Action    | HTTP     
    #   --------------+-----------+----------
    #    Index        | :index    | GET      
    #   --------------+-----------+----------
    #    Create       | :new      | GET      
    #                 | :create   | POST     
    #   --------------+-----------+----------
    #    Read         | :show     | GET      
    #   --------------+-----------+----------
    #    Update       | :edit     | GET      
    #                 | :update   | PUT      
    #   --------------+-----------+----------
    #    Delete       | :delete   | GET      
    #                 | :destroy  | DELETE   
    #   --------------+-----------+----------
    #                                        
    # Additional actions (not yet implemented):                    
    #                                        
    #    Option       | Action    | HTTP      
    #   --------------+-----------+----------
    #    Reordering   | :move     | GET      
    #                 | :reorder  | PUT      
    #   --------------+-----------+----------
    #   
    # Route examples:
    #   
    #   map.resources :projects, :member { :delete => :get }, :collection => { :reorder => :put }
    #
    #   map.move_project 'projects/:id/move/:position', :controller   => 'projects', 
    #                                                   :action       => 'move',
    #                                                   :requirements => { :position => /up|down|top|bottom/ }
    # 
    # 
    # Defaults for ActiveRecord object
    # 
    #   :collection => Proc.new { |finder| finder.find(:all) },
    #   :member     => Proc.new { |finder| finder.find(params[:id]) },
    #   :build      => Proc.new { |finder| finder.is_a?(Class) ? finder.new : finder.build }
    #   
    # Example of use with IQ::Presenter
    # 
    #   :collection => Proc.new { |finder| resource_class.find(:all, :proxy => finder) },
    #   :member     => Proc.new { |finder| resource_class.find(params[:id], :proxy => finder) },
    #   :build      => Proc.new { |finder| resource_class.new(nil, :proxy => finder) }
    #
    def crudify(*args, &block)
      options   = args.extract_options!
      resource  = args.shift
      raise ArgumentError, 'Too many arguments supplied' unless args.empty?
      raise ArgumentError, 'Can\'t specify both :exclude and :only options' if options[:exclude] && options[:only]
      unless options[:collection].nil? || [Symbol, Proc].include?(options[:collection].class)
        raise ArgumentError, ':collection must be a Symbol or Proc'
      end

      if resource && options[:finder]
        raise ArgumentError, ':finder option should be used as an alternative, not in addition to resource name/class'
      end
      
      # Work out which modules need including
      defaults = %w(index show new create edit update delete destroy)
      
      validate_crud_actions = Proc.new do |option|
        raise ArgumentError, ":#{option} should be in: [:#{defaults.join(', :')}]" if defaults.index(option.to_s).nil?
        option.to_s
      end
      
      modules = (only = options[:only]) && Array(only).map(&validate_crud_actions) ||
      (exclude = options[:exclude]) && defaults - Array(exclude).map(&validate_crud_actions) ||
      defaults

      # Get the resource class from first argument if supplied
      unless resource.nil?
        write_inheritable_attribute :resource_class, case resource
          when Class          : resource
          when Symbol, String : resource.to_s.classify.constantize
          else raise ArgumentError, 'Resource class must be supplied as Class, String or Symbol'
        end
      end
      
      write_inheritable_attribute :resource_plural,     self.controller_name
      write_inheritable_attribute :resource_singular,   self.controller_name.singularize
      write_inheritable_attribute :crudify_options,     options

      # Default views
      self.append_view_path(File.join(File.dirname(__FILE__), '..', 'views'), :exclude_controller_path => true)
      
      include ::IQ::Crud::Base
      helper  ::IQ::Crud::Helper
      
      # Include the relevant modules
      modules.each { |m| include "::IQ::Crud::Actions::#{m.classify}".constantize }
      
      handler = ::IQ::Crud::BaseHandler.new
      crudify_config_procs.each { |proc| handler.instance_eval(&proc) }
      handler.instance_eval(&block) if block_given?
      write_inheritable_attribute :crudify_responses, handler.responses
    end
  end
end