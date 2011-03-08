class ProjectsController < InheritedResources::Base
  def new
    @project = Project.new
    @project_states = ProjectState.all
  end

  def show
    @project = Project.find(params[:id])
    @number_of_inactive_tasks = @project.tasks.where(:inactive => true).size 
  end

  def edit
    @project = Project.find(params[:id])
    @project_states = ProjectState.all
  end
end
