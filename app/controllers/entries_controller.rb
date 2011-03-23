class EntriesController < ApplicationController
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :get_tasks_by_project, :only => [:new, :edit, :index]

  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    set_day(@entry, params)
    if @entry.save
      redirect_to new_entry_path, :notice => 'Entry was created.'
    else
      redirect_to new_entry_path, :alert => @entry.errors
     end
  end

  # Call from jQuery with the selected date. Get all entries related to that
  # date from the current user.
  def new
    @entry = Entry.new
    # When having created or updaten an entry, flash[:day] will be set.
    # When having clicked the calender widget params[:day] will be set.
    # Otherwise the user just wants to enter an entry for today.
    # TODO: Is setting the flash good practice? See set_day()
    day = params[:day] ? Date.parse(params[:day]) : flash[:day] || Date.today
    @entry.day = day
    get_entries(@entry, current_user)
  end

  def update
    @entry = Entry.find(params[:id])
    set_day(@entry, params)
    if @entry.update_attributes(params[:entry])
       redirect_to new_entry_path 
    else
       @subjects = Subject.find(:all)
       render :action => 'edit'
    end
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def edit
    @entry = Entry.find(params[:id])
    get_entries(@entry, current_user)
  end

  def destroy
    Entry.find(params[:id]).destroy
    flash[:notice] = "Successfully destroyed entry."
    redirect_to new_entry_path
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
  # TODO: Is setting the flash a good method? Plus: For sake of consistency the
  # flash should also be set by the calendar widget. This code will look more
  # DRY.
  def set_day(entry, params)
    flash[:day] = params[:entry][:day] ? params[:entry][:day] : entry.day
  end

  def get_entries(entry, user)
    @entries = Entry.find_all_by_user_id_and_day(user.id, entry.day)
  end
end
