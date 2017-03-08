class ForgotPasswordsController < ApplicationController
  before_action :redirect_logged_in

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user
      UserMailer.password_reset(@user).deliver
      redirect_to reset_process_path
    else
      flash[:error] = "Invalid email. Please try again."
      redirect_to reset_path
    end
  end

  def edit
    @user = User.find_by(token: params[:token])
    @user ? render(:edit) : render(:expired)
  end

  def update
    @user = User.find_by(token: params[:user][:token])
    @user.password = params[:user][:password]
    if @user.valid?
      @user.update_column(:token, SecureRandom.urlsafe_base64)
      redirect_to login_path
    else
      render :edit
    end
  end
end
