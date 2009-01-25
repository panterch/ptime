class UsersController < ApplicationController

  before_filter :authorize, :except => [ :new, :create ]

  def new
    @user ||= User.new
    render :template => 'users/new'
  end

  def show
    edit
  end

  def edit
    @user = @current_user
    render :template => 'users/edit'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'User was successfully created, welcome.'
      redirect_to entries_url
    else
      new
    end
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User updated.'
      redirect_to user_url
    else
      edit
    end
  end

  protected

end
