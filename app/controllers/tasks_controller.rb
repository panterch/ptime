class TasksController < InheritedResources::Base

  skip_authorization_check

  respond_to :js

end
