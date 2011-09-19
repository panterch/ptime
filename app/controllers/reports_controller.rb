class ReportsController < ApplicationController

  def show
    # Initialize meta_search's collection
    @report = Entry.search(params[:search])
    @users = User.all
    @active_projects = Project.active
    respond_to do |format|
      format.html do
        @entries = @report.paginate(:per_page => 15,
                                        :page => params[:page])
        duration = @report.all.sum(&:duration)
        @total_time = convert_minutes_to_hh_mm(duration)
      end

      format.csv do
        export_to_csv(@report.all)
      end
    end
  end

end
