class Admin::CountriesController < Admin::BaseController
  before_filter :root_required
  crudify
end
