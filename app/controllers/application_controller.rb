class ApplicationController < ActionController::Base
  require 'csv'
  protect_from_forgery
  before_filter :authenticate_user!
  helper_method :sort_direction, :sort_column, :export_to_csv

  # Helper methods for sorting tables
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

  # Works for controllers derived from inherited resources. Otherwise
  # end_of_association_chain() needs to be defined with the model's class as
  # return value.
  # If no sort parameter is given, the table will be sorted by the id.
  def sort_column
    end_of_association_chain.column_names.include?(params[:sort]) ? \
      params[:sort] : end_of_association_chain.column_names[1]
  end

  # Converts minutes to HH:MM format
  def convert_minutes_to_hh_mm(minutes)
    (minutes / 60).to_s + ":" + "%02i" % (minutes % 60).to_s
  end

  # Generates CSV
  def export_to_csv(records)
    result = StringIO.new
    CSV::Writer.generate(result, ',') do |csv|
      csv << ["User name", "Day", "Duration (hours)", "Task name",
        "Description", "Billable"]
      records.each do |r|
        csv << [r.project.shortname, r.user.username, r.day,
          r.duration_hours, r.task.name, r.description, r.billable]
      end
    end
    result.rewind
    send_data(result.read,
              :type => 'text/csv; charset=iso-8859-1; header=present',
              :filename => "report_#{Date.today}.csv")
  end
end
