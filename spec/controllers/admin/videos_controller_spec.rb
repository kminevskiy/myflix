require "spec_helper"
require "rails_helper"

describe Admin::VideosController do
  describe "GET new" do
    let(:admin) { Fabricate(:user, admin: true) }
    let(:alice) { Fabricate(:user, admin: false) }

    context "with admin user" do
      before do
        session[:user_id] = admin.id
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @video" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end

    context "with regular user" do
      before do
        session[:user_id] = alice.id
        get :new
      end

      it "redirects to the home page" do
        expect(response).to redirect_to(home_path)
      end
    end

    context "with unauthenticated user" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, admin: true) }

    before do
      session[:user_id] = user.id
    end

    context "with valid input" do
      before do
        post :create, params: { video: Fabricate.attributes_for(:video) }
      end

      it "adds new video" do
        expect(Video.count).to eq(1)
      end

      it "redirects to the videos page" do
        expect(response).to redirect_to videos_path
      end
    end

    context "with invalid input" do
      let(:category) { Fabricate(:category) }

      before do
        post :create, params: { video: { title: "Something", description: "", category_id: category.id } }
      end

      it "does not create new video" do
        expect(Video.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end
end
