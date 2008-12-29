module IQ::Crud::Actions::Index
  def self.included(base)
    base.crudify_config do
      response_for :index do |format|
        format.html # index.html.erb
        format.js   # index.js.erb
        format.xml  { render :xml => current_collection }
      end
    end
  end
  
  # GET /products
  # GET /products.xml
  def index
    instance_variable_set "@#{resource_plural}", find_collection
    response_for :index
  end
end