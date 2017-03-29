require "spec_helper"
require "rails_helper"

describe ReviewsController, :vcr do
  describe "POST create" do
    context "with authenticated user" do
      let(:video) { Fabricate(:video) }
      let(:current_user) { Fabricate(:user) }

      context "with valid input" do
        before do
          session[:user_id] = current_user.id
          post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review - video association" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review - user association" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid input" do
        let (:video) { Fabricate(:video) }

        before do
          session[:user_id] = current_user.id
          post :create, params: { review: { content: "", rating: 5 } , video_id: video.id }
        end

        it "does not create a review with blank comment body" do
          expect(Review.count).to eq(0)
        end

        it "renders the videos show template" do
          expect(response).to render_template "videos/show"
        end

        it "sets @video variable" do
          expect(:video).to_not be_nil
        end

        it "sets @reviews variable" do
          review1 = Fabricate(:review, video: video)
          review2 = Fabricate(:review, video: video)
          expect(assigns(:reviews)).to match_array([review1, review2])
        end
      end
    end

    context "with unauthenticated user" do
      let(:video) { Fabricate(:video) }

      before do
        post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
      end

      it "redirect to the log in path" do
        expect(response).to redirect_to login_path
      end
    end
  end
end
