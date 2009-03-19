# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

# admin forms
#--------------------
  def field_selector( f, field, field_class = nil )
    unless field_class
      field_id_symbol = (field + "_id").to_sym 
      field_class     = field.classify.constantize
    else
      field_id_symbol = field.to_sym
    end
    "
      <dt>#{ f.label field_id_symbol                                                                    }</dt>
      <dd>#{ f.collection_select field_id_symbol , field_class.all, :id, :name, :prompt => '-- Selecione --' }</dd>
    "
  end

  def associate_nn_selector(m,r1,r2,sf,ef,options)
    options[:member]          = m
    options[:resource1]       = r1
    options[:resource2]       = r2
    options[:show_field]      = sf 
    options[:table_rows]      = 3
    options[:extra_fields]    = ef 
    options[:resource2_key]   = r2.to_s+"2_id" if options[:mode] == :itself
    options[:path_controller] = '/admin/associations'
    "<h2>#{options[:resource2].pluralize.humanize}</h2>" +  association_javascript(options) + "<br />"
  end

# shows
#----------------------------
  def render_full_info_element(element, item, tag_class=nil)
    case element[:render_type]
      when 'normal'
        return "" if (value = item.send element[:attribute]).blank?
        attribute = element[:attribute].humanize
      when 'id_field'
	attribute = element[:attribute][0..-4]
	element[:label_field] ||= 'name'
	value = attribute.classify.constantize.find_by_id(item.send(element[:attribute])).send element[:label_field]
	attribute = attribute.humanize
      when 'simple'
	attribute = element[:attribute].humanize
	value     = element[:value]
      when 'subcategories'
        "teste"      
      when 'yes_or_no'
	attribute = element[:attribute].humanize
        value     = (item.send element[:attribute]) ? "yes" : "no"
      else
	return ""
    end
    "<tr #{'class='+tag_class unless tag_class.blank?}> <td>#{attribute}:</td> <td>#{value}</td> </tr>"
  end

  def render_related(name, list)
    unless list.empty?
      out  = "<div id='related-#{name.gsub(/_/,"-")}' class='related-items'>"
      out += "<h4>#{name.humanize}</h4>"
      out += "<ul>"
      list.each do | item |
        out += "<li>"
        out += "<p>"
        out += link_to(item[:title], item[:path], :title => item[:description])
        out += "</p>"
        out += "</li>"
      end
      out += "</ul>"
      out += "</div>"
    else
      ""
    end
  end

  def render_prizes_list(item)
    if item.prizes
      out = "<div class='field'> <h4>Prémios:</h4> <ul>"
      item.prizes.each do |prize|
        out += "<li>"
        out += "<p>"
        out += link_to(prize.title, prize_path(prize), :title => prize.description_for(item))
        out += "</p>"
        out += "</li>"
      end
      out + "</ul></div>"
    else
      ""
    end
  end	  
  def render_field_div(title, content, options={})
    if options[:path]
      "<div class='field'> <h4>#{title}:</h4><p>" + 
        link_to(content, options[:path], :title => options[:description]) + 
      "</p></div>"
    else   
      "<div class='field'> <h4>#{title}:</h4><p>" + content + "</p></div>"
    end
  end

  def render_category_and_subs(item)
    out = item.category && item.category.name || "none"
    item.subcategories.each { |s| out += ", #{s.name}" }
    out
  end

  def render_field (item, field)
    "<div class='field'> <h4>#{field.humanize}:</h4> <p>#{item.send field}</p></div>" unless item.send(field).blank?
  end

  def render_youtube(url)
    ' <object width="425" height="344">
        <param name="movie" value="http://www.youtube.com/v/'+url+'&fs=1&rel=0&color2=0x666666&color1=0x54abd6"></param>
        <param name="allowFullScreen" value="true"></param>
        <param name="allowscriptaccess" value="always"></param>
        <embed src="http://www.youtube.com/v/' + url +'&fs=1&rel=0&color1=0x006699&color2=0x54abd6" 
               type="application/x-shockwave-flash" 
               allowscriptaccess="always" 
               allowfullscreen="true" 
               width="425" height="344">
        </embed>
      </object>
    ' unless url.blank?
  end

end
