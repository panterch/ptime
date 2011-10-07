class ErrorsController < ApplicationController
  skip_authorization_check

  def render_403
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end
end
