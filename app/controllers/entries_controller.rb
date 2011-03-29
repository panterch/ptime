class EntriesController < ApplicationController
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :get_tasks_by_project, :only => [:new, :edit, :index]
  before_filter :get_entry, :only => [:edit, :update, :destroy]

  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    day = get_day(@entry, params)
    if @entry.save
      flash[:notice] = 'Entry was created.'
      redirect_to new_entry_path(:day => day)
    else
      flash[:alert] = @entry.errors
      redirect_to new_entry_path(:day => day)
    end
  end

  # Call from jQuery with the selected date. Get all entries related to that
  # date from the current user.
  def new
    @entry = Entry.new
    # When having created or updated an entry, params[:day] will be set.
    # Clicking on the calendar widget will also set params[:day].
    # Otherwise the user just wants to enter an entry for today.
    day = params[:day] ? Date.parse(params[:day]) : Date.today
    @entry.day = day
    get_entries(@entry, current_user)
  end

  def update
    day = get_day(@entry, params)
    @entry.update_attributes(params[:entry])
    flash[:notice] = "Successfully updated entry."
    redirect_to new_entry_path(:day => day)
  end

  def edit
    get_entries(@entry, current_user)
  end

  def destroy
    day = @entry.day
    @entry.destroy
    flash[:notice] = "Successfully destroyed entry."
    redirect_to new_entry_path(:day => day)
  end

  def index
    redirect_to :controller => 'report', :action => 'index'
  end


  protected

  def get_active_projects
    @active_projects = Project.active
  end

  # Prefetch all tasks and group them by projects
  def get_tasks_by_project
    @tasks_by_project = Hash.new
    Project.active.each do |p|
      @tasks_by_project[p.id] = p.tasks.map do |t| 
        { :id => t.id, :name => t.name }
      end
    end
  end

  # Preset :day when loading the new entry form. Coming from update,
  # entry.day is set, coming from create, params[:entry][:day] is set.
  def get_day(entry, params)
    params[:entry][:day] ? params[:entry][:day] : entry.day
  end

  def get_entries(entry, user)
    @entries = Entry.find_all_by_user_id_and_day(user.id, entry.day)
  end

  def get_entry
    @entry = Entry.find(params[:id])
  end
end
