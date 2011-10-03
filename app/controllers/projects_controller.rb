class ProjectsController < InheritedResources::Base
  before_filter :set_project_states, :only => [:new, :edit]
  before_filter :load_projects

  load_and_authorize_resource

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

  # cannot use IR method 'collection', because load_and_authorize_resource
  # would prefetch the resource and overwrite the here defined sort order.
  def load_projects
    @projects ||= end_of_association_chain.order(sort_column + " " + sort_direction)
  end
end
