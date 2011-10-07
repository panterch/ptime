class AdminController < InheritedResources::Base
  prepend_before_filter :only_admin

  skip_authorization_check

  def index
  end

  private

  def only_admin
    render_403 unless current_user.admin
  end

end
