module IQ::AssociationsNn::Helper::JsNnAssociation
  def association_javascript(options ={})
    resource1             = options[:resource1]
    resource2             = options[:resource2]
    association           = options[:association] || "#{resource1}_#{resource2}"
    path_controller       = options[:path_controller]
    resource2_checked_ids = options[:checked_ids].to_param
    resource1_id          = options[:member_id].to_s || nil
    extra_fields          = options[:extra_fields].to_param
    show_field            = options[:show_field]
    resource2_id          = options[:resource2_id] || ""
    
    javascript  = '<script src="'     + path_controller     + '/new.js?' 
    javascript += 'resource1='        + resource1        
    javascript += '&resource2='       + resource2         
    javascript += '&resource2_id='    + resource2_id         
    javascript += '&association='     + association  
    javascript += '&path_controller=' + path_controller   
    javascript += '&extra_fields='    + extra_fields
    javascript += '&show_field='      + show_field  
    javascript += '&resource2_checked_ids='             + resource2_checked_ids          
    javascript += '&resource1_id='    + resource1_id   unless resource1_id.nil?
    javascript += '"" type="text/javascript"></script>'
    content_for(:head) { javascript }
    
    div = '<div id="' + "#{association}" + '" > <script type="text/javascript">'
    if options[:checked_ids].empty?
      div + "add_#{association}_button_init" + '();</script> </div>'
    else 
      div + "get_#{association}_list" + '();</script> </div>'
    end
    
  end
end
