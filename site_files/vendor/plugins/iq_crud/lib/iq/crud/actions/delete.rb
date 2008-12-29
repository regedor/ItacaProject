module IQ::Crud::Actions::Delete
  def self.included(base)
    base.crudify_config do
      response_for :delete do |format|
        format.html # delete.html.erb
        format.js   # delete.js.erb
      end
    end
  end
  
  # GET /products/1/delete
  def delete
    instance_variable_set "@#{resource_singular}", find_member
    response_for :delete
  end
end