require "spec_helper"
require "rails_helper"

describe SessionsController do
  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }

    context "with valid credentials" do
      before do
        post :create, params: { email: alice.email, password: alice.password }
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid credentials" do
      before do
        post :create, params: { email: "incorrect@example.com", password: "some_password"}
      end

      it "does not put user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "renders the login form again" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clears the session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the home path" do
      expect(response).to redirect_to root_path
    end
  end
end
