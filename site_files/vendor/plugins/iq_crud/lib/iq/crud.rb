module IQ # :nodoc:
  module Crud # :nodoc:
    autoload(:ResponseHandler,  File.join(File.dirname(__FILE__), 'crud', 'response_handler'))
    autoload(:BaseHandler,      File.join(File.dirname(__FILE__), 'crud', 'base_handler'))
    
    autoload(:Base,     File.join(File.dirname(__FILE__), 'crud', 'base'))
    autoload(:Helper,   File.join(File.dirname(__FILE__), 'crud', 'helper'))

    module Actions
      autoload(:Index,    File.join(File.dirname(__FILE__), 'crud', 'actions', 'index'))
      autoload(:Show,     File.join(File.dirname(__FILE__), 'crud', 'actions', 'show'))
      autoload(:New,      File.join(File.dirname(__FILE__), 'crud', 'actions', 'new'))
      autoload(:Create,   File.join(File.dirname(__FILE__), 'crud', 'actions', 'create'))
      autoload(:Edit,     File.join(File.dirname(__FILE__), 'crud', 'actions', 'edit'))
      autoload(:Update,   File.join(File.dirname(__FILE__), 'crud', 'actions', 'update'))
      autoload(:Delete,   File.join(File.dirname(__FILE__), 'crud', 'actions', 'delete'))
      autoload(:Destroy,  File.join(File.dirname(__FILE__), 'crud', 'actions', 'destroy'))
    end
    
    module Extensions # :nodoc:
      autoload(:ActionController, File.join(File.dirname(__FILE__), 'crud', 'extensions', 'action_controller'))
    end
  end
end