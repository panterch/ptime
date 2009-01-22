module EntriesHelper

  def projects_collection
    @current_user.projects.collect { |p| [ p.description, p.id ] }
  end

  def tasks_collection
    return [] unless @entry.project
    @entry.project.tasks.collect { |t| [ t.name, t.id ] }
  end

end
