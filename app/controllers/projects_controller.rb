class ProjectsController < ApplicationController

  def index
    @projects = @current_user.projects
    render 
  end

  def new
    @project = Project.new
    @project.tasks.build
    render
  end

  def edit
    @project = @current_user.projects.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      @current_user.projects << @project
      flash[:notice] = 'Project successfully created.'
      redirect_to projects_url
    else
      render :template => 'projects/new'
    end
  end

  def update
    @project = @current_user.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project successfully updated.'
      redirect_to projects_url
    else
      render :template => 'projects/edit'
    end
  end


end
