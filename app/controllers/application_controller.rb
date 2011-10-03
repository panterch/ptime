class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  helper_method :sort_direction, :sort_column

  rescue_from CanCan::AccessDenied do
    render_403
  end

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

  protected

    def render_403
      render :file => "#{Rails.root}/public/403.html", :status => 403
    end

end
