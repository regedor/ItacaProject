module IQ::AssociationsNn::Extensions::ActionController # :nodoc:
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def nn_associaize
      
      self.append_view_path(File.join(File.dirname(__FILE__), '..', 'views'), :exclude_controller_path => true)
      
      define_method "new" do
        respond_to do |format|
          format.js  {
            @registry = registry
          }
            
          format.html  { 
            ids = params[:resource2_checked_ids].split '/'
            id  = params[:resource1_id].to_i if params[:resource1_id]

            @associations = registry[:CLASS][:Resource2].find(:all).map do | resource2 | 
             registry[:CLASS][:Association].new(
               registry[:resource2_id] => resource2.id, 
               :association_should_exist => ((ids.include? resource2.id.to_s)? "1" : "0")
             )
            end

            if id && id>0
              resource1 = registry[:CLASS][:Resource1].find(id)
              associations = {}
              (resource1.send registry[:associations]).each do | a | 
                a.association_should_exist = ( ids.include?((a.send registry[:resource2_id]).to_s) || ids.empty? ) ? "1" : "0" 
                associations[(a.send registry[:resource2_id]).to_s.to_sym] = a 
              end
              @associations.map! do | new_association | 
                associations[(new_association.send registry[:resource2_id]).to_s.to_sym] || new_association
              end
            end

            @registry = registry
            render :layout => false
          }
        end 
      end
      
      
      define_method "edit" do
        @resource1 = registry[:CLASS][:Resource1].find(params[:id])
        
        associations = {}
        (@resource1.send registry[:associations]).each do | a | 
          a.association_should_exist = "1" 
          associations[a.send registry[:resource2_id]]= a 
        end
        
        @associations = registry[:CLASS][:Resource2].find(:all).map do | resource2 | 
          associations[resource2.id] || (registry[:CLASS][:Association].new :event_id => resource2.id)
        end
    
        @registry = registry
        render :layout => false
      end

      # :resource
      define_method "valid_resource_name" do |resource|
        resource #&& resource[/#{App::MAIN_MODELS.join('|')}/]
      end
      
      define_method "valid_resource_class" do |resource|
        #App::MAIN_MODEL_LOOKUP[current_resource_name]
        (valid_resource_name resource).constantize
      end
      
      define_method "registry" do
        {
          :CLASS => {
            :Resource1   => valid_resource_class (params[:resource1].classify),
            :Resource2   => valid_resource_class (params[:resource2].classify),
            :Association => valid_resource_class("#{params[:association]}".classify)
          },
          :resource1         => params[:resource1],
          :resource2         => params[:resource2],
          :resource2_id      => "#{params[:resource2]}_id",
          :association       => params[:association],
          :associations      => "#{params[:association]}".pluralize,
          :path_controller   => params[:path_controller],
          :extra_fields      => params[:extra_fields],
          :show_field        => params[:show_field],
          :VALUE => {
            :resource2_checked_ids      => params[:resource2_checked_ids],#.split '/'
            :resource1_id               => params[:resource1_id]
          }
        }
      end
    end
  end
end
