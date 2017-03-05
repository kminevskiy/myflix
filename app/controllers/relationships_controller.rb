class RelationshipsController < ApplicationController
  before_action :redirect_to_sign_in

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    if current_user.new_relationship?(leader.id) && current_user != leader
      Relationship.create(leader: leader, follower: current_user)
    end
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end
