# Methods added to this helper will be available to all templates in the application.
module Admin::BaseHelper
  def link_to_home(name)
    return name if controller.request.request_uri.chomp('/').empty?
    link_to(name, '/', :title => 'link to homepage')
  end

  def nav_item(name, url_options = {}, html_options = {}, *parameters_for_method_reference)
    nav_tag     = html_options.delete(:tag)         || 'li'
    tag_opts    = html_options.delete(:tag_options) || {}
    active_tag  = html_options.delete(:active_tag)  || 'strong'
    match_url   = html_options.delete(:match_url)   || url_options
    exact_match = html_options.delete(:exact_match) || false

    current_url = controller.request.request_uri.chomp('/')
    nav_url     = (match_url.is_a?(String) ? match_url : url_for(match_url)).chomp('/')
    match       = (current_url == nav_url)

    content_tag(
      nav_tag, if match
        content_tag active_tag, name, html_options
      else
        link_to name, url_options, html_options, *parameters_for_method_reference
      end, if match || (!nav_url.blank? && exact_match.blank? && current_url =~ /^#{nav_url}.*/)
        tag_opts.merge(:class => 'current')
      else
        tag_opts
      end
    )
  end
  
  def element(sym, vars = {}, &block)
    vars.each { |key, val| content_for(key.to_sym, val) }
    render :layout => ['/elements', sym.to_s].join('/'), &block
  end
  
  def date_select(object_name, method, options = {})
    super object_name, method, options.merge(:start_year => 1850)
  end


# admin forms
#--------------------
  def field_selector( f, field, field_class = nil )
    unless field_class
      field_id_symbol = (field + "_id").to_sym 
      field_class     = field.classify.constantize
    else
      field_id_symbol = field.to_sym
    end
    options = [HashObject.new :id => nil, :name => '-- Selecione --'] + field_class.all
    "
      <dt>#{ f.label field_id_symbol                                                                    }</dt>
      <dd>#{ f.collection_select field_id_symbol , options, :id, :name }</dd>
    "
  end

  def authors_field_selector_with_js(f, m)
    out  = field_selector f, "author"
    out += "<div id=\"add_more_authors\">"
    out += field_selector f, "author_2_id", Author
    out += field_selector f, "author_3_id", Author             
    out += "</div>"
    if m.author_2_id.blank? and m.author_3_id.blank? 
      out += "<script>  $(\"#add_more_authors\").hide(); </script>"
      out += "<a href=\"#\" onclick=\"$('#add_more_authors').show();$(this).hide();\"> Adicionar mais autores </a>"
      out += "<p></p>"
    end
    return out
  end

  def directors_field_selector_with_js(f, m)
    out  = field_selector f, "director"
    out += "<div id=\"add_more_directors\">"
    out += field_selector f, "director_2_id", Director
    out += field_selector f, "director_3_id", Director           
    out += "</div>"
    if m.director_2_id.blank? and m.director_3_id.blank? 
      out += "<script>  $(\"#add_more_directors\").hide(); </script>"
      out += "<a href=\"#\" onclick=\"$('#add_more_directors').show();$(this).hide();\"> Adicionar mais realizadores </a>"
      out += "<p></p>"
    end
    return out
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

end
