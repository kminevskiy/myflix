class SessionsController < ApplicationController
  before_action :redirect_logged_in, only: [:new]

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash[:error] = "Your account has been suspended, please contact customer service."
        redirect_to login_path
      end
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
