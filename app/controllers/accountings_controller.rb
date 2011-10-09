class AccountingsController < ApplicationController
  before_filter :prepare_parent

  authorize_resource

  def create
    @accounting = @project.accountings.build(params[:accounting])

    respond_to do |format|
      if @accounting.save
        format.html do
          redirect_to edit_project_url(@project),
            :notice => 'Accounting position successfully created.'
        end
        format.js { render :reload }
      else
        format.any(:html, :js) { render :new }
      end
    end
  end

  def new
    @accounting = @project.accountings.build
    render :partial => 'form'
  end

  def edit
    @accounting = @project.accountings.find(params[:id])
    render :partial => 'form'
  end

  def update
    @accounting = @project.accountings.find(params[:id])

    respond_to do |format|
      if @accounting.update_attributes(params[:accounting])
        if params[:accounting][:delete_document]
          @accounting.document = nil
          @accounting.save
        end
        format.html do
          redirect_to edit_project_url(@project),
            :notice => 'Successfully updated accounting position.'
        end
        format.js { render :reload }
      else
        format.any(:html, :js) { render :edit }
      end
    end
  end

  def destroy
    accounting = Accounting.find(params[:id])
    accounting.destroy
    flash[:notice] = 'Successfully destroyed accounting.'
    redirect_to edit_project_url(@project)
  end

  protected

  def prepare_parent
    @project = Project.find(params[:project_id])
  end
end
