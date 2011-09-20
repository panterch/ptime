class AccountingsController < ApplicationController
  before_filter :prepare_parent

  def index
    @search = @project.accountings.search(params[:search])
    @accountings = @search.all
    @project_return = @search.sum(:amount)
  end

  def create
    @accounting = @project.accountings.build(params[:accounting])

    if @accounting.save
      redirect_to project_accountings_url(@project), :notice => 'Accounting position successfully created.'
    else
      render :action => 'new'
    end
  end

  def new
    @accounting = @project.accountings.build
  end

  def edit
    @accounting = @project.accountings.find(params[:id])
  end

  def update
    @accounting = @project.accountings.find(params[:id])
    if @accounting.update_attributes(params[:accounting])
      flash[:notice] = 'Successfully updated accounting position.'
      redirect_to project_accountings_url(@project)
    else
      render :action => 'edit'
    end
  end

  protected

  def prepare_parent
    @project = Project.find(params[:project_id])
  end
end
