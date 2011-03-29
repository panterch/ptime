class ReportController < ApplicationController
  before_filter :get_active_projects, :only => :index
  before_filter :populate_search, :only => :index
  before_filter :get_users, :only => :index

  def index
    respond_to do |format|
      format.html do
        @entries = @report.all.paginate(:per_page => 15,
                                        :page => params[:page])

        duration = @entries.sum(&:duration)
        @total_time = (duration / 60).to_s + ":" + (duration % 60).to_s
        render :template => 'report/index.html.haml'
      end

      format.csv do
        send_data @report.all.to_comma,
                  :type => 'text/csv',
                  :filename=>"report_#{Date.today}.csv"
      end
    end
  end

  protected

  # Initialize meta_search's collection
  def populate_search
    @report = Entry.search(params[:report])
  end

  def get_users
    @users = User.all
  end

  def get_active_projects
    @active_projects = Project.active
  end
end
