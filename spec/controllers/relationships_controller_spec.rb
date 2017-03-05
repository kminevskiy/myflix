require "spec_helper"
require "rails_helper"

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      relationship = Fabricate(:relationship, follower: user, leader: alice)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires authenticated user" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires authenticated user" do
      let(:action) { delete :destroy, params: { id: 4 } }
    end

    it "deletes the relationship if the current user is the follower" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      relationship = Fabricate(:relationship, follower: user, leader: alice)
      delete :destroy, params: { id: relationship }
      expect(Relationship.count).to eq(0)
    end

    it "redirects to the people page" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      relationship = Fabricate(:relationship, follower: user, leader: alice)
      delete :destroy, params: { id: relationship }
      expect(response).to redirect_to people_path
    end

    it "does not delete the relationship if the current user is not the follower" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      relationship = Fabricate(:relationship, follower: alice, leader: user)
      delete :destroy, params: { id: relationship }
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "requires authenticated user" do
      let(:action) { post :create, params: { leader_id: 3 } }
    end

    it "redirects to the people page" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      post :create, params: { leader_id: alice.id }
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      post :create, params: { leader_id: alice.id }
      expect(user.following_relationships.first.leader).to eq(alice)
    end

    it "does not create a relationship if the current user already follows the leader" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = user.id
      Fabricate(:relationship, follower: user, leader: alice)
      post :create, params: { leader_id: alice.id }
      expect(Relationship.count).to eq(1)
    end

    it "does not follow themselves" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, params: { leader_id: user.id }
      expect(Relationship.count).to eq(0)
    end
  end
end
