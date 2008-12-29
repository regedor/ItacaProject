module IQ::Crud::Actions::Show
  def self.included(base)
    base.crudify_config do
      response_for :show do |format|
        format.html # show.html.erb
        format.js   # show.js.erb
        format.xml  { render :xml => current_member }
      end
    end
  end
  
  # GET /products/1
  # GET /products/1.xml
  def show
    instance_variable_set "@#{resource_singular}", find_member
    response_for :show
  end
end