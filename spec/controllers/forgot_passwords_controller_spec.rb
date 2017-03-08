require "spec_helper"
require "rails_helper"

describe ForgotPasswordsController do
  describe "GET new" do
    let(:user) { Fabricate(:user) }

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
      end

      it "redirects to the home page" do
        get :new
        expect(response).to redirect_to videos_path
      end
    end

    context "with unauthenticated user" do
      it "renders the new template" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    context "with valid user" do
      let(:user) { Fabricate(:user) }

      before do
        ActionMailer::Base.deliveries.clear
        post :create, params: { email: user.email }
      end

      it "redirects to reset confirmation" do
        expect(response).to redirect_to reset_process_path
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "sends password recovery email" do
        message = ActionMailer::Base.deliveries.last
        expect(message).to have_content(user.full_name)
      end
    end

    context "with invalid user" do
      before do
        post :create, params: { email: "someone@example.com" }
      end

      it "redirects to the forgot password page" do
        expect(response).to redirect_to reset_path
      end

      it "shows error message" do
        expect(flash[:error]).not_to be_nil
      end
    end

    context "with blank input" do
      it "redirects to forgot password page" do
        post :create, params: { email: "" }
        expect(response).to redirect_to reset_path
      end

      it "shows an error message" do
        post :create, params: { email: "" }
        expect(flash[:error]).not_to be_nil
      end
    end

  describe "GET edit" do
    let(:user) { Fabricate(:user) }

    context "with valid token" do
      before do
        get :edit, params: { token: user.token }
      end

      it "renders the edit template" do
        expect(response).to render_template :edit
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "with invalid token" do
      it "renders the expired template" do
        get :edit, params: { token: "12345"}
        expect(response).to render_template :expired
      end
    end
  end

  describe "PUT update" do
    context "with valid parameters" do
      let(:alice) { Fabricate(:user) }

      before do
        patch :update, params: { id: alice.token, user: { password: "test1234", token: alice.token } }
      end

      it "finds correct user" do
        expect(assigns(:user)).to eq(alice)
      end

      it "updates the user's token" do
        expect(assigns(:user).password).to eq("test1234")
      end

      it "makes previous token invalid" do
        old_token = alice.token
        expect(alice.reload.token).not_to eq(old_token)
      end

      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid parameters" do
      let(:alice) { Fabricate(:user) }

      it "renders the edit template" do
        patch :update, params: { id: alice.token, user: { password: "test", token: alice.token } }
        expect(response).to render_template :edit
      end

      it "does not change user's token" do
        old_token = alice.token
        patch :update, params: { id: alice.token, user: { password: "test", token: alice.token } }
        expect(alice.token).to eq(old_token)
      end
    end
  end
  end
end
