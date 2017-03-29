class AdminsController < ApplicationController
  before_action :require_admin

  def require_admin
    if current_user
      redirect_to home_path unless current_user.admin?
    else
      redirect_to login_path
    end
  end
end
