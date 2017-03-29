require "spec_helper"
require "rails_helper"

describe QueueItemsController, :vcr do
  context "with authenticated user" do
    set_users
    set_videos_and_queue_items

    describe "GET index" do
      before do
        session[:user_id] = current_user.id
      end

      it "sets @queue_items of current_user" do
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "renders the queue template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "POST create" do
      context "with valid credentials" do
        before do
          session[:user_id] = current_user.id
        end

        it "redirects to the index queue template" do
          post :create, params: { video_id: video1.id }
          expect(response).to redirect_to my_queue_path
        end

        it "updates queue_items for the user" do
          post :create, params: { video_id: video1.id }
          expect(QueueItem.count).to eq(1)
        end

        it "creates a queue item that is associated with the video" do
          post :create, params: { video_id: video1.id }
          expect(QueueItem.first.video).to eq(video1)
        end

        it "creates a queue item that is associated with the user" do
          post :create, params: { video_id: video1.id }
          expect(QueueItem.first.user).to eq(current_user)
        end

        it "updates queue only if video is not in the queue already" do
          post :create, params: { video_id: video1.id }
          expect(current_user.queue_items.count).to eq(1)
        end

        it "puts the new video last in the queue" do
          matrix = Fabricate(:video, title: "Matrix")
          Fabricate(:queue_item, video: matrix, user: current_user)
          spiderman = Fabricate(:video, title: "Spiderman")
          post :create, params: { video_id: spiderman.id }
          spiderman_queue_item = QueueItem.where(video: spiderman, user: current_user).first
          expect(spiderman_queue_item.position).to eq(2)
        end
      end

      context "with unauthenticated user" do
        it_behaves_like "requires authenticated user" do
          let(:action) { post :create, params: { video_id: 1 } }
        end
      end
    end

    describe "DELETE destroy" do
      before do
        session[:user_id] = current_user
      end

      it "redirect to the my_queue page" do
        delete :destroy, params: { id: queue_item1.id }
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        queue_item1 = Fabricate(:queue_item, position: 1, user: current_user, video: video1, rating: 5)
        Fabricate(:queue_item, position: 2, user: current_user, video: video2, rating: 4)
        delete :destroy, params: { id: queue_item1.id }
        expect(current_user.queue_items.count).to eq(1)
      end

      it "does not delete the queue item if the current user doesn't own that item" do
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, params: { id: queue_item.id }
        expect(alice.queue_items.count).to eq(1)
      end

      it_behaves_like "requires authenticated user" do
        let (:action) do
          queue_item = Fabricate(:queue_item)
          delete :destroy, params: { id: queue_item.id }
        end
      end

      it "normalizes queue items positions" do
        queue_item1 = Fabricate(:queue_item, position: 1, user: current_user, video: video1, rating: 5)
        queue_item2 = Fabricate(:queue_item, position: 2, user: current_user, video: video2, rating: 4)
        delete :destroy, params: { id: queue_item1.id }
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    describe "POST update_queue" do
      context "with valid inputs" do
        before do
          session[:user_id] = current_user.id
        end

        it "redirects to my_queue page" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2, position: 1 }] }
          expect(response).to redirect_to my_queue_path
        end

        it "reorders queue items" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2, position: 1 }] }
          expect(current_user.queue_items).to eq([queue_item2, queue_item1])
        end

        it "normalizes the position numbers" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 3 }, { id: queue_item2, position: 2 }] }
          expect(current_user.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context("with review rating") do
        before do
          session[:user_id] = current_user.id
        end

        it "creates a new review if no review exists for the video" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 1, rating: 5 }] }
          review = video1.reviews.where(user: current_user).first
          expect(review.rating).to eq(5)
        end

        it "does not create a new review if review exists for this video by this user" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 1, rating: 5 }] }
          expect(video1.reviews.where(user: current_user).count).to eq(1)
        end

        it "updates review when rating is selected and there is no custom review comment" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 1, rating: 5 }] }
          review = video1.reviews.where(user: current_user).first
          expect(review.rating).to eq(5)
          expect(review.content).to eq("An excellent movie")
        end

        it "does not update the review comment when new rating is selected" do
          Fabricate(:review, video: video1, user: current_user, rating: 4, content: "I love this movie!")
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 1, rating: 5 }] }
          review = video1.reviews.where(user: current_user).first
          expect(review.rating).to eq(5)
          expect(review.content).to eq("I love this movie!")
        end

        it "removes review if no rating selected" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 1, rating: "" }] }
          expect(Review.count).to eq(0)
        end
      end

      context "with invalid inputs" do
        before do
          session[:user_id] = current_user.id
        end

        it "redirects back to the my_queue page" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 3.4 }, { id: queue_item2, position: 2 }] }
          expect(response).to redirect_to my_queue_path
        end

        it "sets the flash error message" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 3.4 }, { id: queue_item2, position: 2 }] }
          expect(flash[:error]).to be_present
        end

        it "doesn't change the queue items" do
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2, position: 1.2 }] }
          expect(queue_item1.reload.position).to eq(1)
        end
      end

      context "with unauthenticated user" do
        it_behaves_like "requires authenticated user" do
          let(:action) { post :update_queue }
        end
      end

      context "with queue items that do not belong to the current user" do
        it "does not change items that do not belong to the current user" do
          session[:user_id] = current_user.id
          another_user = Fabricate(:user)
          queue_item2 = Fabricate(:queue_item, user: another_user, video: video2, position: 2)
          post :update_queue, params: { queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2, position: 1 }] }
          expect(queue_item2.reload.position).to eq(2)
        end
      end
    end
  end

  context "with unauthenticated user" do
    describe "GET index" do
      it_behaves_like "requires authenticated user" do
        let(:action) { get :index }
      end
    end
  end
end
