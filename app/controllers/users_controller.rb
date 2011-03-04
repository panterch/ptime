class UsersController < InheritedResources::Base
  def show
    redirect_to users_path
  end
end
