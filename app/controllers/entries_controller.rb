class EntriesController < ApplicationController
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :get_tasks_by_project, :only => [:new, :edit, :index]
  before_filter :get_entry, :only => [:edit, :update, :destroy]

  def create
    @entry = current_user.entries.new(params[:entry])
    day = get_day
    if @entry.save
      flash[:notice] = 'Entry was created.'
      redirect_to new_entry_path(:day => day)
    else
      flash[:alert] = @entry.errors
      redirect_to new_entry_path(:day => day)
    end
  end

  def new
    @entry = Entry.new
    # When having created or updated an entry, params[:day] will be set.
    # Clicking on the calendar widget will also set params[:day].
    # Otherwise the user just wants to enter an entry for today.
    day = params[:day] ? Date.parse(params[:day]) : Date.today
    @entry.day = day
    @entries = get_entries_for_user
  end

  def update
    day = get_day
    @entry.update_attributes(params[:entry])
    flash[:notice] = "Successfully updated entry."
    redirect_to new_entry_path(:day => day)
  end

  def edit
    @entries = get_entries_for_user
  end

  def destroy
    day = @entry.day
    @entry.delete
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
  def get_day
    params[:entry][:day] ? params[:entry][:day] : @entry.day
  end

  # When clicking the calendar widget in the new entry form, jQuery redirects
  # to the new action. In the form, all entries for the selected day and logged
  # in user are to be displayed.
  def get_entries_for_user
    current_user.entries.find_all_by_day(@entry.day)
  end

  def get_entry
    begin
      @entry = current_user.entries.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_entry_path
    end
  end
end
