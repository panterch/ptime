class MilestonesController < ApplicationController
  before_filter :prepare_parent

  authorize_resource

  def index
    @milestones = @project.milestones.all
  end

  def create
    @milestone = @project.milestones.build(params[:milestone])

    if @milestone.save
      redirect_to project_milestones_url(@project), :notice => 'Milestone successfully created.'
    else
      render :action => 'new'
    end
  end

  def new
    @milestone = @project.milestones.build
  end

  def destroy
    milestone = Milestone.find(params[:id])
    milestone.destroy
    flash[:notice] = 'Successfully destroyed milestone.'
    redirect_to project_milestones_url(@project)
  end

  protected

  def prepare_parent
    @project = Project.find(params[:project_id])
  end
end
