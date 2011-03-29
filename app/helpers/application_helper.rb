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
    if options[:action] == controller.action_name and \
       options[:controller] == controller.controller_name
       link_to(name, options, :class => 'active')
    elsif current_user
      link_to(name,options)
    end

  end

  # Prevent rendering of newlines in the view
  def one_line(&block)
    haml_concat capture_haml(&block).gsub("\n", '').gsub('\\n', "\n")
  end

end
