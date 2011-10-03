class ReportsController < ApplicationController
  load_and_authorize_resource

  def show

    # Initialize meta_search's collection
    @report = Entry.search(params[:search])

    # Non-admin users can only see their own timesheet
    if current_user.admin
      @users = User.all
    else
      @users = [current_user]
    end

    @active_projects = Project.active
    respond_to do |format|
      format.html do
        @entries = @report.paginate(:per_page => 15,
                                        :page => params[:page])
        duration = @report.all.sum(&:duration)
        @total_time = convert_minutes_to_hh_mm(duration)
      end

      format.csv do
        send_data @report.all.to_comma,
                  :type => 'text/csv',
                  :filename=>"report_#{Date.today}.csv"
      end
    end
  end

end
