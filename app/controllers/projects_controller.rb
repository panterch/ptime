class ProjectsController < InheritedResources::Base
  before_filter :fetch_project_states, :only => [:new, :edit]

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @number_of_inactive_tasks = @project.tasks.where(:inactive => true).size 
  end

  def edit
    @project = Project.find(params[:id])
  end

  def fetch_project_states
    @project_states = ProjectState.all
  end
end
