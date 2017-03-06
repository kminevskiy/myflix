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
        expect(response).to redirect_to forgot_passwords_path
      end

      it "shows error message" do
        expect(flash[:error]).not_to be_nil
      end
    end

    context "with blank input" do
      it "redirects to forgot password page" do
        post :create, params: { email: "" }
        expect(response).to redirect_to forgot_passwords_path
      end

      it "shows an error message" do
        post :create, params: { email: "" }
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe "GET edit" do
  end

  describe "POST update" do
  end

  describe "GET show" do
  end
end
