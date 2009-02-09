#association_javascript :resource1       => 'document', 
#                       :resource2       => 'media_item',
#                       :association     => 'document_media_item',
#                       :path_controller => '/admin/associations', 
#                       :extra_fields    => [], 
#                       :show_field      => 'name', 
#                       :checked_ids     => (current_member.document_media_items.map(&:media_item_id)), 
#                       :member_id       => (current_member.id.to_s),
#                       :resource2_key   => nil,
#                       :table_rows      => 3

module IQ::AssociationsNn::Helper::JsNnAssociation
  def association_javascript(options ={})
    resource1             = options[:resource1].to_s
    resource2             = options[:resource2].to_s
    association           = (options[:association] && options[:association].to_s) || 
                            (options[:mode] && options[:mode].to_sym == :invert && "#{resource2}_#{resource1}") || 
                            "#{resource1}_#{resource2}"
    path_controller       = options[:path_controller]
    if options[:member]
      options[:checked_ids] = options[:member].send(association.pluralize).map &((options[:resource2_key] || resource2+'_id').to_sym)
      options[:member_id]   = options[:member].id
    end
    resource2_checked_ids = options[:checked_ids].to_param || ""
    resource1_id          = options[:member_id].to_s
    extra_fields          = options[:extra_fields].to_param || ""
    show_field            = options[:show_field].to_s
    resource2_id          = options[:resource2_key].to_s
    table_rows            = options[:table_rows].to_s
    
    javascript  = '<script src="'           + path_controller        + '/new.js?' 
    javascript += 'resource1='              + resource1        
    javascript += '&resource2='             + resource2         
    javascript += '&resource2_id='          + resource2_id         
    javascript += '&association='           + association  
    javascript += '&path_controller='       + path_controller   
    javascript += '&extra_fields='          + extra_fields
    javascript += '&show_field='            + show_field  
    javascript += '&resource2_checked_ids=' + resource2_checked_ids          
    javascript += '&resource1_id='          + resource1_id
    javascript += '&table_rows='            + table_rows
    javascript += '"" type="text/javascript"></script>'
    content_for(:head) { javascript }
    
    div = '<div id="' + "#{association}" + '" > <script type="text/javascript">'
    if options[:checked_ids].empty?
      div + "add_#{association}_button_init" + '();</script> </div>'
    else 
      div + "get_#{association}_list" + '();</script> </div>'
    end
  end
  
  
  #def association_javascript(options ={})
  #  #array params should be set to nil if emtpy
  #  options[:association]           = "#{options[:resource1] }_#{options[:resource2] }" unless options[:association]
  #  options[:resource2_checked_ids] = (options[:checked_ids] && options[:checked_ids].empty?) ? nil : options[:checked_ids]
  #  options[:extra_fields]          = nil if (options[:extra_fields] && options[:extra_fields].empty?)
  #  options[:resource1_id]          = options.delete(:member_id).to_s if options[:member_id]  
  #  options[:resource2_id]          = options.delete(:resource2_key) 
  #  
  #  javascript  = '<script src="' + options[:path_controller] + '/new.js?'+ options.to_param + '"" type="text/javascript"></script>'
  #  content_for(:head) { javascript }
  #  
  #  '<div id="' + "#{options[:association]}" + '" > <script type="text/javascript">' + if options[:resource2_checked_ids]
  #    "add_#{options[:association]}_button_init" + '();</script> </div>'
  #  else 
  #    "get_#{options[:association]}_list" + '();</script> </div>'
  #  end
  #end
  
end
