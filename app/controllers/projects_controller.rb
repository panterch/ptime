class ProjectsController < InheritedResources::Base
  before_filter :set_project_states, :only => [:new, :edit]

  def create
    create!{ projects_path }
  end

  def update
    update!{ projects_path }
  end

  def new
    new! { resource.set_default_tasks }
  end

  protected

  def set_project_states
    @project_states = ProjectState.all
  end

end
