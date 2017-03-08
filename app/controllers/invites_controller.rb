class InvitesController < ApplicationController
  before_action :redirect_to_sign_in

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.user = current_user
    if email_used?(invite_params[:email])
      render :new
    else
      if @invite.save
        UserMailer.invite_user(@invite).deliver
        redirect_to invite_confirmation_path
      else
        render :new
      end
    end
  end

  private

  def email_used?(email)
    User.pluck(:email).include?(email.downcase)
  end

  def invite_params
    params.require(:invite).permit(:full_name, :email, :message)
  end
end
