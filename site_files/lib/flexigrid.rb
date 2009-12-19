module Flexigrid
  private
  def default_flex_data(resource_class,default_sort_name)
    page      = params[:page].to_i
    rp        = params[:rp].to_i
    query     = params[:query]
    qtype     = params[:qtype]
    sortname  = params[:sortname]
    sortorder = params[:sortorder]
  
    sortname  = default_sort_name  unless sortname
    sortorder = "desc"  unless sortorder
    page      = 1       unless page
    rp        = 10      unless rp

    start = ((page-1) * rp).to_i
    query = "%"+query+"%"
  
    
    if query == "%%" 
      # No search terms provided
      @resources = resource_class.find( :all,
  	    :order  => sortname + ' ' + sortorder,
  	    :limit  => rp,
  	    :offset => start
  	  )
      count = resource_class.count :all 
    else  
      # User provided search terms
      @resources = resource_class.find( :all,
        :order      => sortname + ' ' + sortorder,
        :limit      => rp,
  	    :offset     => start,
  	    :conditions => [qtype + " like ?", query]
  	  )
      count = resource_class.count :all, :conditions => [qtype + " like ?", query] 
    end
  
    # Construct a hash from the ActiveRecord result
    return_data         = Hash.new()
    return_data[:page]  = page
    return_data[:total] = count
    return return_data
  end
end
