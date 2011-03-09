require 'csv'

class EntriesController < InheritedResources::Base
  before_filter :fetch_active_projects, :only => [:new, :edit, :index]

  # Helper method to render the index page in html
  def format_html(params)
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
  def format_csv
    @search = Entry.search(session[:search])
    @entries = @search.all
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
        csv << ["Start", "End", "Project", "User"]
        @entries.each do |e|
          csv << [e.start, e.end, Project.find(e.project_id).shortname,
                  User.find(e.user_id).username]
        end
      end
      send_data report.string, :type => "text/csv", 
       :filename=>"report_#{Date.today}.csv",
       :disposition => 'attachment'
  end

  # TODO: Implement respond_with(@entries) instead of respond_to
  def index
    respond_to do |format|
      format.html { format_html params }
      format.csv { format_csv }
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

  def fetch_active_projects
    @active_projects = Project.where(:inactive => false).collect \
      { |p| [p.shortname, p.id] }
  end

end
