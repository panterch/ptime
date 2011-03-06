class ProjectsController < InheritedResources::Base
  # Newly created projects are not inactive
  def create
    project = Project.new(params[:project])
    project.inactive = false
    project.save
    redirect_to projects_path
  end
end
