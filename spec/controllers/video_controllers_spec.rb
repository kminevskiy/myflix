require "spec_helper"
require "rails_helper"

describe VideosController, :vcr do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, params: { id: video.id }

      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, params: { id: video.id }

      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects to a login page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, params: { id: video.id }

      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET search action" do
    it "set @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      matrix = Fabricate(:video, title: "Matrix")
      get :search, params: { query: "trix" }

      expect(assigns(:videos)).to eq([matrix])
    end

    it "redirects to a login page for unauthenticated users" do
      Fabricate(:video, title: "Matrix")
      get :search, params: { query: "trix" }

      expect(response).to redirect_to(login_path)
    end
  end
end
