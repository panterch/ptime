class ControllingController < ApplicationController
  layout 'time'


  def index
    @projects = Project.find(:all, :order => 'inactive, description')
  end

  def generate
    @project = Project.find(params[:id])
    render :partial => 'report'
  end
end
