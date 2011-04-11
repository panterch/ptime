class UsersController < InheritedResources::Base
  prepend_before_filter :only_admin, :only =>[:create, :new, :index]

  def show
    redirect_to :action=>:edit
  end

  def edit
    edit! if check_admin_or_self
  end

  def update
    user_params = params[:user]
    if (user_params!=nil)
      user_params.delete(:password) if user_params[:password].blank?
      user_params.delete(:password_confirmation) if user_params[:password].
          blank? and user_params[:password_confirmation].blank?
    end
    return unless check_admin_or_self
    if current_user.id.to_s == params[:id] && user_params[:password]
      # To change the own password the user must enter the old password
      raise SecurityError unless (user_params[:current_password])
    end
    @user=User.find(params[:id])
    method = params[:user][:password] ? :update_with_password : :update_attributes
    if @user.send(method, params[:user])
      redirect_to users_url, :notice => 'User ' + @user.username + 
        ' updated successfully'
    else
      render :edit
    end
    #update!
  end

  protected
  def only_admin
    if current_user==nil
      redirect_to :controller=>"devise/sessions", :action=>:new
    elsif !current_user.try(:admin?)
      redirect_to failed_redirection_target
    end
  end

  # Redirection-Target if access to resource is denied
  def failed_redirection_target
    projects_path
  end

  private
  # Raise a error if a non-admin tries to access on a foreign user
  def check_admin_or_self
    if !current_user.admin? && params[:id].to_s!=current_user.id.to_s
      redirect_to failed_redirection_target
      false
    else
      true
    end
  end

  def collection
    @users ||= end_of_association_chain.order(sort_column + " " + sort_direction)
  end
end
