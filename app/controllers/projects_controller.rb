class ProjectsController < ApplicationController
  before_filter :prepare_project_states,
    :only => [:new, :edit, :index, :update, :create]
  before_filter :prepare_project_probabilities,
    :only => [:new, :edit, :update, :create]

  authorize_resource

  def index
    @search = Project.search(params[:search])

    # Preset inactive and external by default
    @search.inactive_is_false = true unless params[:search]
    @search.external_is_true = true unless params[:search]
    @search.meta_sort = 'updated_at.desc' unless params[:search]

    @projects = @search.all
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      redirect_to projects_url, :notice => 'Project successfully created.'
    else
      render :action => 'new'
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to projects_url, :notice => 'Successfully updated project.'
    else
      render :action => 'edit'
    end
  end

  def new
    @project = Project.new
    @project.set_default_tasks
    @project.set_default_milestones
    @project.set_default_responsibilities
  end

  def edit
    @project = Project.find(params[:id])

    @accountings_search = @project.accountings.search(params[:search])
    @accountings = @accountings_search.all
    @accountings_sum = @accountings_search.sum(:amount)

    # Calculate the total time for entries
    duration = @project.entries.map(&:duration).sum
    @total_time = convert_minutes_to_hh_mm(duration)
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    flash[:notice] = 'Successfully destroyed project.'
    redirect_to projects_path
  end

  protected

  def prepare_project_states
    @project_states = ProjectState.all
  end

  def prepare_project_probabilities
    @project_probabilities =
      Project::PROBABILITIES.map {|n| ["#{(n*100).to_i}%", n ]}
  end
end
