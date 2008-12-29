module IQ::Crud::Actions::Update
  def self.included(base)
    base.crudify_config do
      response_for :update do |format|
        format.html { redirect_to(collection_path) }
        format.js   # update.js.erb
        format.xml  { head :ok }
      end
      
      response_for :update_failed do |format|
        format.html { render :action => "edit" }
        format.js   { render :action => 'update_failed' }
        format.xml  { render :xml => current_member.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /products/1
  # PUT /products/1.xml
  def update
    instance_variable_set "@#{resource_singular}", find_member
    
    if current_member.update_attributes(params[resource_singular.to_sym])
      flash[:success] = "#{resource_singular.humanize} was successfully updated."
      response_for :update
    else
      response_for :update_failed
    end
  end  
end