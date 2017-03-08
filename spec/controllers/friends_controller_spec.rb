require "spec_helper"
require "rails_helper"

describe FriendsController do
  describe "GET new" do
    let(:user) { Fabricate(:user) }

    context "with unauthenticated user" do
      before do
        Fabricate(:invite, user: user)
        get :new, params: { token: user.token }
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "sets @invited_user" do
        expect(assigns(:invited_user)).to be_instance_of(User)
        expect(assigns(:invited_user)).not_to be_nil
      end

      it "sets @invitee" do
        expect(assigns(:invitee)).to be_instance_of(Invite)
        expect(assigns(:invitee)).not_to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
        get :new, params: { token: user.token }
      end

      it "redirects to the home page" do
        expect(response).to redirect_to videos_path
      end
    end
  end
end
