class EntriesController < ApplicationController

  before_filter :prepare_entries
  before_filter :prepare_entry, :only => [:show, :edit, :destroy, :update]

  def index
    return new
  end

  def new
    # create new record for editing
    @entry = Entry.new
    @entry.date = @date
    respond_to do |format|
      format.html { render :template => 'entries/entries' }
    end
  end

  def show
    edit
  end

  def edit
    respond_to do |format|
      format.html { render :template => 'entries/entries' }
    end
  end

  # Access model to create and save new entry
  def create
    @entry = @current_user.entries.build(params[:entry])
    if @entry.save
      flash[:updated] = @entry.id
      flash[:notice] = 'Entry was successfully created.'
      respond_to do |format|
        format.html { redirect_to entries_url }
      end
    else
      respond_to do |format|
        format.html { render :template => 'entries/entries' }
      end
    end
  end

  # delete a record
  def destroy
    @entry.destroy
    flash[:notice] = 'Entry destroyed.'
    redirect_to entries_url
  end

  # Access model to update an existing record
  def update
    if @entry.update_attributes(params[:entry])
      flash[:updated] = @entry.id
      flash[:notice] = 'Entry was successfully updated.'
      respond_to do |format|
        format.html { redirect_to entries_url }
      end
    else
      respond_to do |format|
        format.html { render :template => 'entries/entries' }
      end
    end
  end

  protected

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



end
