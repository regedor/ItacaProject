class Admin::GenresController < Admin::BaseController
  before_filter :root_required
  crudify
end
