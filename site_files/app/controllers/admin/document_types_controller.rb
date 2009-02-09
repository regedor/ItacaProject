class Admin::DocumentTypesController < Admin::BaseController
  before_filter :root_required
  crudify
end
