require "spec_helper"
require "rails_helper"

describe InvitesController do
  describe "GET new" do
    let(:user) { Fabricate(:user) }

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @invite" do
        expect(assigns(:invite)).to be_instance_of(Invite)
      end
    end

    context "with unauthenticated user" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "POST create" do
    context "with valid input" do
      let(:user) { Fabricate(:user) }

      before do
        ActionMailer::Base.deliveries.clear
        session[:user_id] = user.id
      end

      it "sets @invite" do
        post :create, params: { invite: Fabricate.attributes_for(:invite) }
        expect(assigns(:invite)).to be_instance_of(Invite)
      end

      it "sends an email to the correct recipient" do
        friend = Fabricate.build(:user)
        post :create, params: { invite: { full_name: friend.full_name, email: friend.email, message: "Please join" } }
        recipient = ActionMailer::Base.deliveries.first.to
        expect(recipient).to eq([friend.email])
      end

      it "creates a new invite" do
        friend = Fabricate(:user)
        post :create, params: { invite: { full_name: friend.full_name, email: friend.email, message: "Please join", user: user } }
        new_user = User.find_by(email: friend.email)
        expect(new_user).not_to be_nil
      end

      it "redirects to confirmation page" do
        post :create, params: { invite: Fabricate.attributes_for(:invite) }
        expect(response).to redirect_to invite_confirmation_path
      end
    end

    context "with invalid input" do
      let(:user) { Fabricate(:user) }

      before do
        ActionMailer::Base.deliveries.clear
        session[:user_id] = user.id
      end

      it "does not create a new invite if user with the same email exists" do
        alice = Fabricate(:user)
        friend = Fabricate(:user)
        post :create, params: { invite: { full_name: friend.full_name, email: alice.email, message: "Please join", user: user } }
        expect(Invite.count).to eq(0)
      end

      it "does not send an invitation if user with the same email exists" do
        alice = Fabricate(:user)
        friend = Fabricate(:user)
        post :create, params: { invite: { full_name: friend.full_name, email: alice.email, message: "Please join", user: user } }
        queue = ActionMailer::Base.deliveries
        expect(queue).to be_empty
      end

      it "renders the new template if any of the required fields is empty" do
        post :create, params: { invite: { full_name: "", email: "", message: "Please join", user: user } }
        expect(response).to render_template :new
      end
    end
  end
end
