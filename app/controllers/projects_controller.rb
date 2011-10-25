class ProjectsController < ApplicationController
  before_filter :prepare_project_states,
    :only => [:new, :edit, :index, :update, :create]
  before_filter :prepare_project_probabilities,
    :only => [:new, :edit, :update, :create]
  before_filter :load_chart_data,
    :only => [:edit]

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

  def load_chart_data
    @project = Project.find(params[:id])
    @start_at = 1.year.ago.at_midnight
    @date_range = ((@start_at.to_date) .. (Date.today)).step(10)

    @worktime_per_day = @project.gather_worktime_per_day(@date_range)
    @revenue_per_day = @project.gather_revenue_per_day(@date_range)

    @chart_data = LazyHighCharts::HighChart.new('graph') do |f|
      # Title, description, position and styling
      f.options[:title][:text] = "Controllr"
      f.options[:subtitle][:text] = "Daily overview"
      f.options[:chart][:defaultSeriesType] = "line"
      f.options[:legend][:layout] = "horizontal"
      f.options[:legend][:style][:position] = "relative"
      f.options[:legend][:style][:left] = "auto"
      f.options[:legend][:style][:top] = "auto"
      f.options[:legend][:style][:bottom] = "auto"

      # Plotting options
      # f.options[:plotOptions][:line][:lineWidth] = 1

      # X and Y axis
      f.options[:xAxis][:type] = "datetime"
      f.options[:xAxis][:tickinterval] = 24 * 3600 * 1000 # ten days
      f.options[:xAxis][:categories] = ""

      f.options[:yAxis][:title] = "Value"

      # Collect and fill data for worktime
      worktime_data = @date_range.collect { |day| @worktime_per_day[day] }
      f.series(:name => "Work time",
               :data => worktime_data,
               :pointInterval => 24 * 3600 * 1000,
               :pointStart => @start_at.to_f * 1000)

      # Collect and fill data for revenue
#      revenue_data = @date_range.collect { |day| @revenue_per_day[day] }
      #f.series(:name => "Revenue",
               #:data => revenue_data,
               #:pointInterval => 24 * 3600 * 1000,
               #:pointStart => @start_at.to_f * 1000)
    end
  end
end
