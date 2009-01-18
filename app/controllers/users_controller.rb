class UsersController < ApplicationController

  permit 'admin'

  before_filter :load_users
  before_filter :load_user, :only => [:show, :edit, :update]

  def index
    new
  end

  def new
    @user = User.new
    render :template => 'users/user'
  end

  def show
    edit
  end

  def edit
    render :template => 'users/user'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash.now[:notice] = 'User was successfully created.'
      redirect_to users_url
    else
      edit
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash.now[:notice] = 'User updated.'
      redirect_to users_url
    else
      edit
    end
  end

  protected

    def load_users
      @users = User.find(:all, :order => 'inactive, name')
    end

    def load_user
      @user = User.find(params[:id])
    end

end
