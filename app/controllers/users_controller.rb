class UsersController < ApplicationController
  before_action :redirect_logged_in, only: [:front, :new, :create]
  before_action :redirect_to_sign_in, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(token: params[:id])
  end

  def create
    @user = User.new(user_params)
    referer = User.find_by(token: params[:user][:ref_token])
    result = UserSignup.new(@user).sign_up(params[:stripeToken], referer)
    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix. Please sign in now."
      redirect_to login_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
