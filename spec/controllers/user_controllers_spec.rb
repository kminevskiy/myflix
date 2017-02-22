require "spec_helper"
require "rails_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, params: { user: Fabricate.attributes_for(:user) }
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to login page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid input" do
      before do
        post :create, params: { user: { password: "testtest", full_name: "Test name" } }
      end

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "renders the registration form" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

end
