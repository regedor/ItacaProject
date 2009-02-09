class Admin::UsersController < Admin::BaseController
  before_filter :root_required
  crudify
end
