class ProjectsController < InheritedResources::Base
  before_filter :fetch_project_states, :only => [:new, :edit]

  def show
    show! do
      @number_of_inactive_tasks = @project.tasks.active(false).count 
    end
  end

  protected

  def fetch_project_states
    @project_states = ProjectState.all
  end
end
