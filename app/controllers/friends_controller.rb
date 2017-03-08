class FriendsController < ApplicationController
  before_action :redirect_logged_in

  def new
    @invited_user = User.find_by(token: params[:token])
    @invitee = Invite.find_by(user_id: @invited_user.id)
    @user = User.new(email: @invitee.email)
  end
end
