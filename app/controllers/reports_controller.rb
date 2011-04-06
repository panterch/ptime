class ReportsController < ApplicationController

  def show
    # Initialize meta_search's collection
    @report = Entry.search(params[:report])
    @users = User.all
    @active_projects = Project.active
    respond_to do |format|
      format.html do
        @entries = @report.all.paginate(:per_page => 15,
                                        :page => params[:page])
        duration = @entries.sum(&:duration)
        @total_time = (duration / 60).to_s + ":" + (duration % 60).to_s
      end

      format.csv do
        send_data @report.all.to_comma,
                  :type => 'text/csv',
                  :filename=>"report_#{Date.today}.csv"
      end
    end
  end

end
