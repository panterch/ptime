class EntriesController < ApplicationController

  layout 'time'

  # display an index page holding users records for one day
  def index

    # cache applicable projects
    @projects = Project.find(:all, :conditions => ['inactive = ?', false])

    # assert that there is at least 1 project record
    if 1 > @projects.length
      flash[:notice] ="Please enter at least one project before adding entries."
      redirect_to :controller => 'projects'
      return
    end

    # determine date to display
    @date = date

    # access date's entries
    @entries = Entry.find(:all,
               :conditions => ["date = ? AND user_id = ?", 
               @date, session[:user_id] ],
               :order => 'project_id') 

    # create new entry ready to be added via create or load selected entry
    # for editing
    if @entry.respond_to?(:errors)
      # in error, do nothing
    elsif params[:id]
      # id submitted: edit request
      @entry = Entry.find(:first,
               :conditions => ["id = ? AND user_id = ?",
               params[:id], session[:user_id] ] )
      raise ActiveRecord::RecordNotFound if nil == @entry # just some security
    else
      # create new record for editing
      @entry = Entry.new
      @entry.date = @date
    end

    # compute total time displayed on page
    @total = 0
    @entries.each { | e | @total += e.duration }

    # gather tasks to display for current entry
    @tasks = tasks_for_project(@entry.project_id)

    render :template => 'entries/index'
  end

  # delete a record
  def destroy
    e = Entry.find(:first,
             :conditions => ["id = ? AND user_id = ?",
             params[:id], session[:user_id] ] )
    e.destroy
    redirect_to :action => 'index'
  end

  # create or update a record
  def persist
    if params[:entry][:id].empty?
      create
    else
      update
    end
    index
  end

  # ajax callback to update tasks list when project selected
  def update_tasks
    @tasks = tasks_for_project(params[:project_id])
    render :partial => 'tasks'
  end

  def tasks_for_project(project_id)
    return [] if !project_id
    return tasks = Task.find(:all, :conditions => 
           [ 'project_id = ? AND length(name) > 0', project_id])
  end

  # retrieves the current selected date from parameters or session
  # date can be submitted via form but defaults to today
  def date
    # these are the parameters like they are submitted by rails
    # select_date
    if d = params[:date]
      d = Date.civil(Integer(d[:year]), Integer(d[:month]),
                     Integer(d[:day]))
    # JSCalendar submits 3 http parameters, notice: since these
    # parameters are coming from javascript, january is month 0 (zero)
    elsif params[:y] &&  params[:m] && params[:d] 
      d = Date.civil(Integer(params[:y]), Integer(params[:m]) + 1,
                     Integer(params[:d]))
    # when an entry is saved, we use the date submitted whitin
    elsif params[:entry]
      d = Date.parse(params[:entry][:date])
    # the date in the session is the date that was last selected
    elsif session[:date]
      d = session[:date]
    # no date selected, fallback to today
    else
      d = Date.today
    end
    session[:date] = d
  end


  # Access model to create and save new entry
  def create
    @entry = Entry.new(params[:entry])
    @entry.user_id = session[:user_id]
    if @entry.save
      flash.now[:notice] = 'Entry was successfully created.'
      @entry = nil
    end
  end

  # Access model to update an existing record
  def update
    @entry = Entry.find(:first,
             :conditions => ["id = ? AND user_id = ?",
             params[:entry][:id], session[:user_id] ] )
    if @entry.update_attributes(params[:entry])
      flash.now[:notice] = 'Entry was successfully updated.'
      @entry = nil
    end
  end


end
