class AccountingsController < ApplicationController
  before_filter :set_projects, :only => [:new, :edit, :create]

  def index
    @project = Project.find(params[:project_id])
    @accountings = @project.accountings
    @filter = params[:filter] unless params[:filter].blank?
    @filter ||= {}
    @accountings = @accountings.filter_sent if @filter['sent']
    @accountings = @accountings.filter_payed if @filter['payed']
    @accountings = @accountings.filter_cash_in if @filter['cash_in']
    @accountings = @accountings.filter_cash_out if @filter['cash_out']
    @accountings = @accountings.search(params[:search])
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

  def edit
    @project = Project.find(params[:project_id])
    @accounting = Accounting.find(params[:id])
  end

  def update
    @accounting = Accounting.find(params[:id])
    if @accounting.update_attributes(params[:accounting])
      flash[:notice] = 'Successfully updated accounting position.'
      redirect_to project_accountings_url(@project)
    else
      render :action => 'edit'
    end
  end

  protected

  def set_projects
    @projects = Project.all
  end
end
