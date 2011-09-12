class AccountingsController < ApplicationController
  before_filter :prepare_parent

  def index
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
    @accounting = @project.accountings.build(params[:accounting])

    if @accounting.save
      redirect_to project_accountings_path, :notice => 'Accounting position successfully created.'
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
