class ReportsController < ApplicationController
  authorize_resource

  def show
    # Non-admin users can only see their own timesheet
    if current_user.admin
      @users = User.all
    else
      @users = [current_user]
    end

    respond_to do |format|
      format.html do

        # Initialize meta_search's collection
        #@report = Entry.where(:user_id => user_ids).search(params[:search])
        @report = Entry.search(params[:search])

        @active_projects = Project.active
        @entries = @report.paginate(:per_page => 15,
                                        :page => params[:page])
        duration = @report.all.sum(&:duration)
        @total_time = convert_minutes_to_hh_mm(duration)
      end

      format.csv do
        user_ids = @users.collect { |u| u.id }
        send_data(Entry.csv(user_ids, params[:search]),
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => "report_#{Date.today}.csv")
      end
    end
  end
end
