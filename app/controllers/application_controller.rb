class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :redirect_logged_in, :redirect_to_register

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def redirect_logged_in
    redirect_to root_path if logged_in?
  end

  def redirect_to_register
    redirect_to login_path if !logged_in?
  end
end
