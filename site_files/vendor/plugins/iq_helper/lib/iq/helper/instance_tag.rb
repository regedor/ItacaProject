module IQ::Helper::InstanceTag
  def to_button_tag(text = nil, options = {})
    options = options.stringify_keys
    add_default_name_and_id(options)
    content = (text.blank? ? nil : text.to_s) || method_name.humanize
    content_tag("button", content, options)
  end
end