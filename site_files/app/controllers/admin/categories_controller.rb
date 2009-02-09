class Admin::CategoriesController < Admin::BaseController
  before_filter :root_required
  crudify
end
