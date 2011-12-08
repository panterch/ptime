class ReportsController < ApplicationController
  authorize_resource

  def show
    # Non-admin users can only see their own timesheet
    if current_user.admin
      @users = User.ordered
    else
      @users = [current_user]
    end
    user_ids = @users.collect { |u| u.id }

    # Limit default range to one month
    search_params = limit_default_range(params[:search])

    respond_to do |format|
      format.html do
        # Initialize meta_search's collection
        @report = Entry.where(:user_id => user_ids).search(search_params)
        @report.meta_sort = 'day.asc' unless params[:search]

        @active_projects = Project.active.ordered

        duration = @report.all.sum(&:duration)
        @total_time = convert_minutes_to_hh_mm(duration)
      end

      format.csv do
        send_data(Entry.csv(user_ids, search_params),
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => "report_#{Date.today}.csv")
      end
    end
  end


  private

  # Limits the default search (e.g. if no parameter is given) to the current
  # month and the current user.
  def limit_default_range(search_params)
    return search_params if search_params
    now = Time.now
    current_month_start = DateTime.new(now.year,now.month,1)
    current_month_end = DateTime.now
    { 'day_gte' => current_month_start,
      'day_lte' => current_month_end,
      'user_id_eq' => current_user.id }
  end
end
