module IQ::Crud::Actions::Create
  def self.included(base)
    base.crudify_config do
      response_for :create do |format|
        format.html { redirect_to(collection_path) }
        format.js   # create.js.erb
        format.xml  { render :xml => current_member, :status => :created, :location => member_path(current_member) }
      end
      
      response_for :create_failed do |format|
        format.html { render :action => 'new' }
        format.js   { render :action => 'create_failed' }
        format.xml  { render :xml => current_member.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /products
  # POST /products.xml
  def create
    instance_variable_set "@#{resource_singular}", build_member
    current_member.attributes = params[resource_singular.to_sym]

    if current_member.save
      flash[:success] = "#{resource_singular.humanize} was successfully created."
      response_for :create
    else
      response_for :create_failed
    end
  end
end