# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
end
