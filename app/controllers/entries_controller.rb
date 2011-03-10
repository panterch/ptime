class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :populate_search_params, :only => :new
  respond_to :html
  respond_to :csv, :only => :index

  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    @entry.save
    redirect_to new_entry_path
  end

  # Show active tasks associated to project
  def update_tasks_select
    tasks = Task.where(:project_id => params[:id], :inactive => false).\
      order(:name) unless params[:id].blank?
    render :partial => "tasks_select", :locals => { :tasks => tasks }
  end


  private

  # Display only active projects
  def get_active_projects
    @active_projects = Project.where(:inactive => false).collect \
      { |p| [p.shortname, p.id] }
  end

  def populate_search_params
    @search_params = {}
  end

  def collection
    @users = User.all.collect { |user| [user.username, user.id]}
    @search = Entry.search(params[:search])
    @search_params = { :search => params[:search] }
    @entries = @search.all.paginate(:per_page => 3, :page => params[:page])
  end

end
