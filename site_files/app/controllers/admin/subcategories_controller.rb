class Admin::SubcategoriesController < Admin::BaseController
  before_filter :root_required
  crudify
end
