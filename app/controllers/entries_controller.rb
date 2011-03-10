require 'csv'

class EntriesController < InheritedResources::Base
  before_filter :get_active_projects, :only => [:new, :edit, :index]

  def index
    respond_to do |format|
      format.html { to_html }
      format.csv  { to_csv }
    end
  end

  def create
    @entry = Entry.new(params[:entry])
    @entry.user = current_user
    @entry.save
    redirect_to entries_path
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

  # Helper method for the index action, populating instance variables for the
  # filter form
  def to_html
    @search = Entry.search(params[:search])
    @entries = @search.all.paginate(:per_page => 3, :page => params[:page])

    # Save search parameters for later download
    session[:search] = params[:search]

    # Populate select menus for user and projects
    @users = User.all.collect { |user| [user.username, user.id]}
    # Insert qualifier as search parameter
    @users.insert(0, ["", ""])
    @active_projects.insert(0, ["", ""])
  end

  # Helper method to render the index page in csv
  def to_csv
    @search = Entry.search(session[:search])
    @entries = @search.all
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
        csv << ["Day", "Hours", "Project", "User"]
        @entries.each do |e|
          csv << [e.day, e.duration_hours,
            Project.find(e.project_id).shortname,
            User.find(e.user_id).username]
        end
      end
      send_data report.string, :type => "text/csv", 
       :filename=>"report_#{Date.today}.csv",
       :disposition => 'attachment'
  end

end
