class EntriesController < ApplicationController
  before_filter :load_active_projects_and_tasks_by_project,
    :only => [:new, :edit, :create]
  before_filter :load_entry, :only => [:edit, :update, :destroy]

  authorize_resource

  def create
    @entry = current_user.entries.new(params[:entry])
    if @entry.save
      redirect_to new_entry_path(:day => get_day),
        :notice => 'Entry was created.'
    else
      load_entries_for_user
      load_duration_hours
      @time_capture_method = params[:time_capture_method]
      render :action => "new", :locals => { :day => get_day }
    end
  end

  def new
    @entry = Entry.new
    # When having created or updated an entry, params[:day] will be set.
    # Clicking on the calendar widget will also set params[:day].
    # Otherwise the user just wants to enter an entry for today.
    @entry.day = params[:day] ? Date.parse(params[:day]) : Date.today

    # Determine the most recent entry for pre-selection
    last_entry = current_user.entries.order('updated_at DESC').first
    if last_entry
      @entry.project = last_entry.project
      @entry.task = last_entry.task
    end

    load_entries_for_user
  end

  def update
    if @entry.update_attributes(params[:entry])
      redirect_to new_entry_path(:day => get_day),
        :notice => "Successfully updated entry."
    else
      load_entries_for_user
      load_duration_hours
      load_active_projects_and_tasks_by_project
      render :action => "new", :locals => { :day => get_day }
    end
  end

  def edit
    load_entries_for_user
    load_duration_hours
  end

  def destroy
    day = @entry.day
    @entry.destroy
    flash[:notice] = "Successfully destroyed entry."
    redirect_to new_entry_url(:day => day)
  end


  protected

  def load_active_projects_and_tasks_by_project
    @active_projects = Project.active.order(:shortname)

    # Prefetch all tasks and group them by projects
    @tasks_by_project = Hash.new
    Project.active.each do |p|
      @tasks_by_project[p.id] = p.tasks.active.map do |t|
        { :id => t.id, :name => t.name, :billable => t.billable_by_default }
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
  def load_entries_for_user
    @entries = current_user.entries.find_all_by_day(@entry.day)
    duration = @entries.sum(&:duration)
    @total_time = convert_minutes_to_hh_mm(duration)
  end

  def load_entry
    begin
      @entry = current_user.entries.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end
  end

  # Attempts to obtain a duration value, even for unsaved entries
  def load_duration_hours
    @duration_hours = params[:entry][:duration_hours] if params[:entry]
    @duration_hours ||= @entry.duration_hours if @entry
  end
end
