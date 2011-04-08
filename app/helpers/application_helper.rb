module ApplicationHelper

  # Generic helper for adding fields of a nested model to a form
  # [name] link’s text 
  # [f] the form builder object 
  # [association] name of the ressource in question
  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, 
                          :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)  
    end  
    link_to_function(name, "add_fields(this, \"#{association}\", 
                     \"#{escape_javascript(fields)}\")")
  end  


  # Highlight link for current action
  def section_link(name, options)
    if current_section?(options)
       link_to(name, options, :class => 'active')
    elsif current_user
      link_to(name, options)
    end
  end

  # Helper for section_link; returns true for subactions of any given tab
  def current_section?(options)
    if options[:controller] == controller.controller_name or
      (options[:controller] == 'admin' and controller.controller_name == 'users') or
      (options[:controller] == 'admin' and controller.controller_name == 'project_states')
      true
    end
  end

  # Prevent rendering of newlines in the view
  def one_line(&block)
    haml_concat capture_haml(&block).gsub("\n", ' ').gsub('\\n', "\n")
  end

  # Render column title as sortable link
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

end
