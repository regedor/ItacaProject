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
        <dd>#{ f.collection_select field_id_symbol , field_class.all, :id, :name, :prompt => '--Select--' }</dd>
      "
    end
end
