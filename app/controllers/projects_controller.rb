class ProjectsController < InheritedResources::Base
  def new
    @project = Project.new
    @project_states = ProjectState.all
  end

  def edit
    @project = Project.find(params[:id])
    @project_states = ProjectState.all
  end
end
