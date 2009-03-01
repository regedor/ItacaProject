class Admin::MusicGenresController < Admin::BaseController
  before_filter :root_required
  crudify
end
