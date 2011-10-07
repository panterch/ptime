class ResponsibilityTypesController < ApplicationController
  authorize_resource

  def index
    @responsibility_types = ResponsibilityType.all
  end

  def create
    @responsibility_type = ResponsibilityType.new(params[:responsibility_type])

    if @responsibility_type.save
      redirect_to responsibility_types_url, :notice => 'Responsibility type successfully created.'
    else
      render :action => 'new'
    end
  end

  def update
    @responsibility_type = ResponsibilityType.find(params[:id])
    if @responsibility_type.update_attributes(params[:responsibility_type])
      flash[:notice] = 'Successfully updated responsibility type.'
      redirect_to responsibility_types_url
    else
      render :action => 'edit'
    end
  end

  def new
    @responsibility_type = ResponsibilityType.new
  end

  def edit
    @responsibility_type = ResponsibilityType.find(params[:id])
  end
end
