module IQ::Crud::Actions::Destroy
  def self.included(base)
    base.crudify_config do
      response_for :destroy do |format|
        format.html { redirect_to(collection_path) }
        format.js   # destroy.js.erb
        format.xml  { head :ok }
      end
      
      response_for :destroy_failed do |format|
        format.html { render :action => 'delete' }
        format.js   { render :action => 'destroy_failed' }
        format.xml  { render :xml => current_member, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    instance_variable_set "@#{resource_singular}", find_member
    if current_user.role==User::ROOT || current_member.user_id == current_user.id
      if current_member.destroy
        flash[:success] = "#{resource_singular.humanize} removido com sucesso."
        response_for :destroy
      else
        flash[:failure] = "#{resource_singular.humanize} could not be deleted."
        response_for :destroy_failed
      end
    end
  end
end
