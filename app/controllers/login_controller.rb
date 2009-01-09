class LoginController < ApplicationController

  before_filter :authorize, :except => :login

  layout 'time'

  def index
    # access date's entries
    @users = User.find(:all, :order => 'inactive, name')

    # create new entry ready to be added via create or load selected entry
    # for editing
    if @user.respond_to?(:errors)
      # in error, do nothing
    elsif params[:id]
      # id submitted: edit request
      @user = User.find(params[:id])
    else
      # create new record for editing
      @user = User.new
    end
    render :template => 'login/index'
  end

  # create or update a record
  def persist
    if params[:user][:id].empty?
      create
    else
      update
    end
    # this could have been a setup for an initial user
    if (session[:setup]) and
       0 < User.count(:all, :conditions => ['inactive = ?', false])
       flash[:notice] = 'Setup complete, please log in to proceed'
       session[:setup] = nil
       redirect_to(:controller => 'login', :action => 'login')
       return false
    end
    index
  end

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

  # Access model to create and save new record
  def create
    @user = User.new(params[:user])
    if @user.save
      flash.now[:notice] = 'User was successfully created.'
      @user = nil
    end
  end

  # Access model to update an existing record
  def update
    @user = User.find(params[:user][:id])
    if @user.update_attributes(params[:user])
      flash.now[:notice] = 'User was successfully updated.'
      @user = nil
    end
  end


end
