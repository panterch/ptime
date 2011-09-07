class AccountingsController < ApplicationController
  before_filter :set_projects, :only => [:new, :edit, :create]
  
  def index
    @accountings = Accounting.all
  end

  def create
    @accounting = Accounting.new(params[:accounting])

    respond_to do |format|
      if @accounting.save
        format.html do
          redirect_to accountings_path, :notice => 'Accounting position successfully created.'
        end
      else
        format.html do
          render :action => 'new'
        end
      end
    end
  end

  def new
    @accounting = Accounting.new

    respond_to do |format|
      format.html
    end
  end

  protected

  def set_projects
    @projects = Project.all
  end
end
