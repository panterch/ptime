class ReportController < ApplicationController
  before_filter :get_active_projects, :only => :index
  before_filter :populate_search, :only => :index
  before_filter :get_users, :only => :index

  def index
    respond_to do |format|
      format.html do 
        @entries = @search.all.paginate(:per_page => 3, 
                                        :page => params[:page])
        render :template => 'report/index.html.haml'
      end

      format.csv do 
        send_data @search.all.to_comma, 
          :type => 'text/csv',
          :filename=>"report_#{Date.today}.csv"
      end
    end
  end

  protected

  # Initialize meta_search's collection
  def populate_search
    @search = Entry.search(params[:report])
  end

  def get_users
    @users = User.all
  end

  def get_active_projects
    @active_projects = Project.active
  end
end
