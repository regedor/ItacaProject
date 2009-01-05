module IQ::ViewPathExtensions::ActionView::Base
  def self.included(base) # :nodoc:
    base.send :alias_method_chain, :find_full_template_path,  :exclude_controller_path
    base.send :alias_method_chain, :find_base_path_for,       :exclude_controller_path
  end
        
  private

  def find_full_template_path_with_exclude_controller_path(template_path, extension)
    file_name = "#{template_path}.#{extension}"
    base_path = find_base_path_for(file_name)
    base_path.blank? ? "" : "#{base_path}/#{apply_controller_path_exclusion(base_path, file_name)}"
  end

  def find_base_path_for_with_exclude_controller_path(template_file_name)
    @view_paths.find do |p|
      File.file?(File.join(p, apply_controller_path_exclusion(p, template_file_name)))
    end
  end
  
  def apply_controller_path_exclusion(path, file_name)
    if @controller.class.exclude_controller_path_for?(path)
      file_name.sub(/^#{@controller.controller_path}/, '')
    else
      file_name
    end
  end
end