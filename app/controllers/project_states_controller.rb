class ProjectStatesController < InheritedResources::Base
  load_and_authorize_resource

  def create
    create! { project_states_url }
  end
end
