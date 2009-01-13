# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  before_filter :authorize

  def current_user
    @current_user
  end

  private
  
    def authorize
      # check for valid user_id in session
      if session[:user_id]
        @current_user = User.find(session[:user_id])
        if @current_user.inactive && !@current_user.admin?
          flash[:notice] = 'User inactivated'
          redirect_to( :controller => 'login', :action => 'login' )
          return false
        end
        return true
      end
      flash[:notice] = 'Please log in'
      redirect_to( :controller => 'login', :action => 'login' )
    end

  

end
