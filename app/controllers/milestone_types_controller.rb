class MilestoneTypesController < ApplicationController
  authorize_resource

  def index
    @milestone_types = MilestoneType.all
  end

  def create
    @milestone_type = MilestoneType.new(params[:milestone_type])

    if @milestone_type.save
      redirect_to milestone_types_url, :notice => 'Milestone type successfully created.'
    else
      render :action => 'new'
    end
  end

  def update
    @milestone_type = MilestoneType.find(params[:id])
    if @milestone_type.update_attributes(params[:milestone_type])
      flash[:notice] = 'Successfully updated milestone type.'
      redirect_to milestone_types_url
    else
      render :action => 'edit'
    end
  end

  def new
    @milestone_type = MilestoneType.new
  end

  def edit
    @milestone_type = MilestoneType.find(params[:id])
  end
end
