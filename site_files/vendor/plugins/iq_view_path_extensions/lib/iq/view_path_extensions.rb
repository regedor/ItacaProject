module IQ # :nodoc:
  module ViewPathExtensions # :nodoc:
    autoload(:ActionController, File.dirname(__FILE__)  + '/view_path_extensions/action_controller')
    autoload(:ActionMailer,     File.dirname(__FILE__)  + '/view_path_extensions/action_mailer')
    
    module ActionView
      autoload(:Base,           File.dirname(__FILE__)  + '/view_path_extensions/action_view/base')
      autoload(:TemplateFinder, File.dirname(__FILE__)  + '/view_path_extensions/action_view/template_finder')
    end
  end
end

# Only include extensions if the version of ActionController::Base supports view_paths
if ActionController::Base.respond_to?('view_paths')
  ActionController::Base.send(:include, IQ::ViewPathExtensions::ActionController)
  ActionMailer::Base.send(:include, IQ::ViewPathExtensions::ActionMailer) # Stops ActionMailer from breaking

  if ActionView.const_defined?('TemplateFinder')
    # For Rails versions later than 2.02
    ActionView::TemplateFinder.send(:include, IQ::ViewPathExtensions::ActionView::TemplateFinder)
  else
    begin
      # For Rails versions up to 2.02
      ActionView::Base.send(:include, IQ::ViewPathExtensions::ActionView::Base)
    rescue
      raise 'IQ::ViewPathExtensions will not work with this version of rails'
    end
  end
end