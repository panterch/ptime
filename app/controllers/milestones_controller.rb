class MilestonesController < ApplicationController
  before_filter :prepare_parent

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

  protected

  def prepare_parent
    @project = Project.find(params[:project_id])
  end
end
