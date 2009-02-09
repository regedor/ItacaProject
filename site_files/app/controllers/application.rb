# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e79d0960641b9061fbede0495a77ab2c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #
  def admin_required
    return true if logged_in? && current_user.is_admin?
    session[:return_to] = request.request_uri
    redirect_to(login_path) and flash[:notice] = 'Não autorizado.' and return false
  end

  def root_required
    return true if logged_in? && current_user.is_root?
    session[:return_to] = request.request_uri
    redirect_to(login_path) and flash[:notice] = 'Não autorizado.' and return false
  end
end
