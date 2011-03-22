class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :get_tasks_by_project, :only => [:new, :edit, :index]
  before_filter :get_entries, :only => [:new, :edit]
  before_filter :set_day, :only => [:create, :update]


  # FIXME: This code has to move. With an implementation like this there will
  # be crashes on invalid entries.
  # Problems:
  #  - Can't move code to model, because current_user should only be read in
  #    the controller and is inaccessible in the model.
  #  - Can't move it into a before_filter, because 'resource' can't be assigned
  #    anything before 'create' itself has run: "Couldn't find Entry without an
  #    ID"
  def create
    create! do
      @entry.user = current_user
      new_entry_path
    end
  end

  # Call from jQuery with the selected date. Get all entries related to that
  # date from the current user.
  def new
    new! do
      # When having created or updaten an entry, flash[:day] will be set.
      # When having clicked the calender widget params[:day] will be set.
      # Otherwise the user just wants to enter an entry for today.
      # TODO: Is setting the flash good practice? See set_day()
      day = params[:day] ? Date.parse(params[:day]) : flash[:day] || Date.today
      if day
        @entry = Entry.new
        @entry.day = day
        @entries = Entry.find_all_by_user_id_and_day(current_user.id, @entry.day)
      end
    end
  end

  def update
    update! { new_entry_path }
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

  # Get entries of the entry's day to display them
  def get_entries
    if params[:action] == 'edit'
      day = resource.day
    else
      day = Date.today
    end
    @entries = Entry.find_all_by_user_id_and_day(current_user.id, day)
  end

  # Preset :day when loading the new entry form. Coming from update,
  # resource.day is set, coming from create, params[:entry][:day] is set.
  # TODO: Is setting the flash a good method? Plus: For sake of consistency the
  # flash should also be set by the calendar widget. This code will look more
  # DRY.
  def set_day
    flash[:day] = params[:entry][:day] ? params[:entry][:day] : resource.day
  end
end
