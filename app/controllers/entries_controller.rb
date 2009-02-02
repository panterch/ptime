class EntriesController < ApplicationController

  layout 'time'

  before_filter :prepare_projects, :prepare_date, :prepare_entries
  before_filter :prepare_entry, :only => [:show, :edit, :destroy, :update]

  def index
    return new
  end

  def new
    # create new record for editing
    @entry = Entry.new
    @entry.date = @date
    respond_to do |format|
      format.html { render :template => 'entries/new' }
    end
  end

  def show
    edit
  end

  def edit
    respond_to do |format|
      format.html { render :template => 'entries/new' }
    end
  end

  # Access model to create and save new entry
  def create
    @entry = @current_user.entries.build(params[:entry])
    if @entry.save
      flash.now[:notice] = 'Entry was successfully created.'
      respond_to do |format|
        format.html { redirect_to entries_url }
      end
    else
      respond_to do |format|
        format.html { render :template => 'entries/new' }
      end
    end
  end

  # delete a record
  def destroy
    @entry.destroy
    flash.now[:notice] = 'Entry destroyed.'
    redirect_to entries_url
  end

  # Access model to update an existing record
  def update
    if @entry.update_attributes(params[:entry])
      flash.now[:notice] = 'Entry was successfully updated.'
      respond_to do |format|
        format.html { redirect_to entries_url }
      end
    else
      respond_to do |format|
        format.html { render :template => 'entries/new' }
      end
    end
  end

  protected

    def prepare_projects

      # cache applicable projects
      @projects = Project.find(:all, :conditions => ['inactive = ?', false],
                               :order => 'description')

      # assert that there is at least 1 project record
      if 1 > @projects.length
        flash[:notice] ="Please enter at least one project before adding entries."
        redirect_to :controller => 'projects'
        return
      end

    end

    def prepare_entries
      # access date's entries
      @entries = Entry.find(:all,
                 :conditions => ["date = ? AND user_id = ?", 
                 @date, session[:user_id] ],
                 :order => 'project_id') 

      # compute total time displayed on page
      @total = 0
      @entries.each { | e | @total += e.duration }
    end
     
    def prepare_entry
      # edit & show requests use a given entry
      @entry = @current_user.entries.find(params[:id])
    end

    def prepare_date
      # these are the parameters like they are submitted by rails
      # select_date
      if d = params[:date]
        @date = Date.civil(Integer(d[:year]), Integer(d[:month]),
                       Integer(d[:day]))
      # JSCalendar submits 3 http parameters, notice: since these
      # parameters are coming from javascript, january is month 0 (zero)
      elsif params[:y] &&  params[:m] && params[:d] 
        @date = Date.civil(Integer(params[:y]), Integer(params[:m]) + 1,
                       Integer(params[:d]))
      # this is a show or an edit
      elsif @entry && @entry.date
        @date = @entry.date
      # when an entry is saved, we use the date submitted whitin
      elsif params[:entry]
        @date = params[:entry][:date]
        @date = Date.parse(params[:entry][:date]) unless @date.is_a? Date
      # the date in the session is the date that was last selected
      elsif session[:date]
        @date = session[:date]
      # no date selected, fallback to today
      else
        @date = Date.today
      end
      session[:date] = @date
    end


end
