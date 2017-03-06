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

    if @user.save
      UserMailer.welcome_email(@user).deliver
      redirect_to login_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
