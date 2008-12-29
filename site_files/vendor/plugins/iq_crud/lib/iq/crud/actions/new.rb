module IQ::Crud::Actions::New
  def self.included(base)
    base.crudify_config do
      response_for :new do |format|
        format.html # new.html.erb
        format.js   # new.js.erb
        format.xml  { render :xml => current_member }
      end
    end
  end
  
  # GET /products/new
  # GET /products/new.xml
  def new
    instance_variable_set "@#{resource_singular}", build_member
    response_for :new
  end
end