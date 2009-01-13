# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  before_filter :authorize

  private
  
  def authorize
    # check for valid user_id in session
    if session[:user_id] && (
       @current_user = User.find(:first, 
       :conditions => ['id = ? AND inactive = ?', session[:user_id], false]))
      return true
    end
    # check if there are any users in the database. if there
    # is at least one user show the login screen
    if 0 < User.count(:all, :conditions => ['inactive = ?', false])
      logger.warn "invalid credentials #{request.remote_ip}."
      session[:user_id] = session[:setup] = nil
      flash[:notice] = 'Please log in'
      redirect_to( :controller => 'login', :action => 'login' )
    # otherwise let insert an initial user
    elsif 'login' == controller_name and session[:setup]
      return true
    else
      logger.warn "creating new setup session for #{request.remote_ip}."
      flash[:notice] = 'Please add initial user'
      session[:user_id] = nil
      session[:setup] = true
      redirect_to( :controller => 'login', :action => 'index' )
    end
    # after redirection, we must not render anything
    return false
  end

end
