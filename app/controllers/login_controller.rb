class LoginController < ApplicationController

  before_filter :authorize, :except => :login

  layout 'time'

  # this method shows the login page and tries to authenticate post params
  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to(:controller => 'entries', :action => 'index')
      else
        logger.warn "invalid login #{params[:name]} at #{request.remote_ip}"
        flash[:notice] = 'Invalid user / password combination'
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to( :action => 'login' )
  end

  private

end
