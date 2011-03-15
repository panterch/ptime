class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]
  before_filter :populate_search, :only => :index
  before_filter :get_users, :only => :index

  respond_to :csv, :only => :index

  def create
    create! {
        @entry.user = current_user
        @entry.save
        new_entry_path
      }
  end

  def index
    # Prepare entries for csv export
    index! do |format|
      format.csv do
        @entries_csv = @search.all.collect do |entry|
          [ entry.day, 
            entry.duration_hours, 
            entry.project.shortname,
            entry.user.username].join(',')
        end
      end
    end
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
    @active_projects = Project.where(:inactive => false).collect do |p|
      [p.shortname, p.id] 
    end
  end

  def collection
    @entries ||= @search.all.paginate(:per_page => 3, :page => params[:page])
  end

  # Initialize meta_search's collection
  def populate_search
    @search = Entry.search(params[:search])
  end

  def get_users
    @users = User.all.collect { |user| [user.username, user.id] }
  end

end
