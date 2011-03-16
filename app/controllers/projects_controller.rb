class ProjectsController < InheritedResources::Base
  before_filter :get_project_states, :only => [:new, :edit]
  before_filter :get_number_of_inactive_tasks, :only => :show


  protected

  def get_project_states
    @project_states = ProjectState.all
  end

  def get_number_of_inactive_tasks
    @number_of_inactive_tasks = resource.tasks.active(false).count 
  end
end
