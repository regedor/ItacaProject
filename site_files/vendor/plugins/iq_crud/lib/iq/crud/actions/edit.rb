module IQ::Crud::Actions::Edit
  def self.included(base)
    base.crudify_config do
      response_for :edit do |format|
        format.html # edit.html.erb
        format.js   # edit.js.erb
      end
    end
  end
  
  # GET /products/1/edit
  def edit
    instance_variable_set "@#{resource_singular}", find_member
    response_for :edit if current_user.role==User::ROOT || current_member.user_id == current_user.id
  end 
end
