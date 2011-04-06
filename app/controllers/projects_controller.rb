class ProjectsController < InheritedResources::Base
  before_filter :set_project_states, :only => [:new, :edit]
  before_filter :set_number_of_inactive_tasks, :only => :show

  def new
    new! { resource.set_default_tasks }
  end

  protected

  def set_project_states
    @project_states = ProjectState.all
  end

  def set_number_of_inactive_tasks
    @number_of_inactive_tasks = resource.tasks.active(false).count 
  end
end
