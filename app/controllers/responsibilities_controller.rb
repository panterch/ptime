class ResponsibilitiesController < ApplicationController
  before_filter :prepare_parent
  authorize_resource

  def index
    @responsibilities = @search.all
  end

  def create
    @responsibility = @project.responsibilities.build(params[:responsibility])

    if @responsibility.save
      redirect_to project_responsibilities_url(@project), :notice => 'Responsibility successfully created.'
    else
      render :action => 'new'
    end
  end

  def new
    @responsibility = @project.responsibilities.build
  end

  def edit
    @responsibility = @project.responsibilities.find(params[:id])
  end

  def update
    @responsibility = @project.responsibilities.find(params[:id])
    if @responsibility.update_attributes(params[:responsibility])
      flash[:notice] = 'Successfully updated responsibility.'
      redirect_to project_responsibilities_url(@project)
    else
      render :action => 'edit'
    end
  end

  def destroy
    responsibility = Responsibility.find(params[:id])
    responsibility.mark_as_deleted
    flash[:notice] = 'Successfully destroyed responsibility.'
    redirect_to project_responsibilities_url(@project)
  end

  protected

  def prepare_parent
    @project = Project.find(params[:project_id])
  end
end
