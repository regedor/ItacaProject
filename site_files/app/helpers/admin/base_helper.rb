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
end
