require 'json'

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

  # Helper method for new/edit
  def projects_select(form, projects)
    form.input :project_id, :as => :select, 
      :collection => to_form_select(projects)
  end

  # Extract information a form select method
  def to_form_select(projects)
    projects.collect do |p|
      [p.shortname, p.id] 
    end
  end

end
