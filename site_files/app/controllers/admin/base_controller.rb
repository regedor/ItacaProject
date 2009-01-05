class Admin::BaseController < ApplicationController
  #before_filter :ensure_administrator
 # before_filter :admin_required

  #private
  #
  #def ensure_administrator
  #  authenticate_or_request_with_http_basic('Admin') do |username, password|
  #    (username == 'soniciq' && password == 'thelucid007') || (username == 'admin' && password == 'b4b1dg3')
  #  end
  #end
end
