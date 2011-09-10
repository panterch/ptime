class AccountingsController < ApplicationController
  before_filter :set_projects, :only => [:new, :edit, :create]
  
  def index
    @project = Project.find(params[:project_id])
    @accountings = @project.accountings
  end

  def create
    @project = Project.find(params[:project_id])
    @accounting = @project.accountings.build(params[:accounting])

    respond_to do |format|
      if @accounting.save
        format.html do
          redirect_to project_accountings_path, :notice => 'Accounting position successfully created.'
        end
      else
        format.html do
          render :action => 'new'
        end
      end
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @accounting = @project.accountings.build

    respond_to do |format|
      format.html
    end
  end

  protected

  def set_projects
    @projects = Project.all
  end
end
