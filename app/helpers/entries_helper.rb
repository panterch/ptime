module EntriesHelper

  # Build user select for entries report form
  def users_id_equals_select(form)
    users = @users.collect { |user| [user.username, user.id] }
    form.select :user_id_equals, users,  {:include_blank => ''}
  end

  def tasks_collection
    return []  unless @entry.project
    @entry.project.tasks.collect { |t| [t.name, t.id] }
  end

  def get_tasks_by_projects
    @tasks_by_project.to_json
  end

  # Helper method for index (entries report)
  def projects_select_id_equals(form, projects)
    form.select :project_id_equals, to_form_select(projects),
      {:include_blank => ''}
  end

  # Extract information a form select method
  def to_form_select(projects)
    projects.collect do |p|
      [project_identifier(p), p.id]
    end
  end

  # Extract projects grouped by past usage
  def grouped_project_select(projects, f)

    # Get the projects from the last month that entries were created for
    project_ids = current_user.entries.where("updated_at >= ?", 1.month.ago).collect { |e| e.project.id }
    # Calculate the frequency of each project_id ( i.e. {1=>3, 3=>1} )
    frequency = project_ids.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    # Get the four most frequently used projects
    uniq_project_ids = project_ids.sort_by { |v| frequency[v] }.uniq[0..4]
    recent_projects = uniq_project_ids.collect { |id| Project.find id }

    unless recent_projects.empty?
      selected_value = f.object.read_attribute(:project_id)
      group = [['recent projects',to_form_select(recent_projects)],
        ['all projects',to_form_select(projects)]]
      return grouped_options_for_select(group, selected_value)
    else
      return to_form_select(projects)
    end
  end

  # Truncated project identifier (shortname & part of the description)
  def project_identifier(p, length=26)
    truncate([p.shortname, p.description].join(" - "), :length => length)
  end

  # Display an edit link if the entry belongs to the logged in user
  def display_edit_link(entry)
    if entry.user == current_user
      link_to (image_tag 'edit.png'), edit_entry_path(entry)
    end
  end

  def time_capture_method_state(method)
    (method.nil? or method == 'start_end') ? true : false
  end

  def entry_project_description(entry)
    truncate(entry.project.shortname +
             ' - ' + entry.project.description, :length => 45)

  end

end
