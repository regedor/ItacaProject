# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

# shows
#----------------------------
  def render_full_info_element(element, item, tag_class=nil, pdf=nil)
    case element[:render_type]
      when 'normal'
        return nil if (value = item.send element[:attribute]).blank?
        attribute = element[:attribute].humanize
      when 'id_field'
	attribute = element[:attribute][0..-4]
	element[:label_field] ||= 'name'
	return nil unless a = attribute.classify.constantize.find_by_id(item.send(element[:attribute]))
	value = a.send element[:label_field]
	attribute = attribute.humanize
      when 'simple'
	attribute = element[:attribute].humanize
	value     = element[:value]
      when 'subcategories'
	attribute = "subcategories".humanize
        value = item.category && item.category.name || "--"
        item.subcategories.each { |s| value += ", #{s.name}" }
      when 'yes_or_no'
	attribute = element[:attribute].humanize
        value     = ((item.send element[:attribute]) ? "yes" : "no").humanize
      else
	return nil
    end
    value = value.to_s + element[:at_end] if element[:at_end] and not value.blank?
    if pdf
      [attribute,value]
    else
      "<tr #{'class='+tag_class unless tag_class.blank?}> <td class='column-title'>#{attribute}</td> <td><p>#{value}</p></td> </tr>"
    end
  end

  def render_related(name, list)
      out  = "<div id='related-#{name.gsub(/_/,"-")}' class='related-items'>"
      out += "<h4#{' class="'+name.singularize+'"'}>#{name.humanize}</h4>"
      out += "<ul>"
      list.each do | item |
        out += "<li>"
        out += "<p>"
        out += link_to( h(truncate(item[:title],50,"...")), item[:path], :title => item[:description], :class => name.singularize)
        out += "</p>"
        out += "</li>"
      end

      out += "<p><span class='empty-data'>(sem #{name.humanize.downcase})</span></p>" if list.empty?
      out += "</ul>"
      out += "</div>"
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
      "<div class='field'> <h4#{' class="'+options[:class]+'"' if options[:class]}>#{title}</h4><p>" + 
        link_to(content, options[:path], :title => options[:description], :class => options[:class]) + 
      "</p></div>"
    else   
      "<div class='field'> <h4>#{title}</h4><p>" + content + "</p></div>"
    end
  end

  def render_category_and_subs(item)
    out = item.category && item.category.name || "vazio"
    item.subcategories.each { |s| out += ", #{s.name}" }
    out
  end

  def render_field (item, field)
    "<div class='field'> <h4>#{field.humanize}</h4> <p>#{item.send field}</p></div>" unless item.send(field).blank?
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
