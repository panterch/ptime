class ReportsController < ApplicationController

  def show
    respond_to do |format|
      format.html do
        # Initialize meta_search's collection
        @report = Entry.search(params[:search])
        @users = User.all
        @active_projects = Project.active
        @entries = @report.paginate(:per_page => 15,
                                        :page => params[:page])
        duration = @report.all.sum(&:duration)
        @total_time = convert_minutes_to_hh_mm(duration)
      end

      format.csv do
        send_data(Entry.csv(params[:search]),
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => "report_#{Date.today}.csv")
      end
    end
  end

end
