require "spec_helper"
require "rails_helper"

describe QueueItemsController do
  context "with authenticated user" do
    let(:current_user) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }

    describe "GET index" do
      it "sets @queue_items of current_user" do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
        queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
        session[:user_id] = current_user.id

        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "renders the queue template" do
        session[:user_id] = current_user.id
        get :index
        expect(response).to render_template :index
      end
    end

    describe "POST create" do
      it "redirects to the index queue template" do
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, params: { video_id: video.id }
        expect(response).to redirect_to my_queue_path
      end

      it "updates queue_items for the user" do
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, params: { video_id: video.id }
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item that is associated with the video" do
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, params: { video_id: video.id }
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a queue item that is associated with the user" do
        session[:user_id] = current_user.id
        video = Fabricate(:video)
        post :create, params: { video_id: video.id }
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "updates queue only if video is not in the queue already" do
        session[:user_id] = current_user.id
        category = Fabricate(:category, name: "Comedy")
        video = Fabricate(:video, category: category)
        Fabricate(:review, video: video, user: current_user)
        Fabricate(:queue_item, video: video, user: current_user)

        post :create, params: { video_id: video.id }
        expect(current_user.queue_items.count).to eq(1)
      end

      it "puts the new video last in the queue" do
        session[:user_id] = current_user.id
        matrix = Fabricate(:video, title: "Matrix")
        Fabricate(:queue_item, video: matrix, user: current_user)
        spiderman = Fabricate(:video, title: "Spiderman")
        post :create, params: { video_id: spiderman.id }
        spiderman_queue_item = QueueItem.where(video: spiderman, user: current_user).first
        expect(spiderman_queue_item.position).to eq(2)
      end

      it "redirects to log in page for unauthenticated users" do
        post :create, params: { video_id: 1 }
        expect(response).to redirect_to login_path
      end
    end

    describe "DELETE destroy" do
      it "redirect to the my_queue page" do
        session[:user_id] = current_user
        queue_item = Fabricate(:queue_item)
        delete :destroy, params: { id: queue_item.id }
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        session[:user_id] = current_user
        queue_item = Fabricate(:queue_item)
        delete :destroy, params: { id: queue_item.id }
        expect(current_user.queue_items.count).to eq(0)
      end

      it "does not delete the queue item if the current user doesn't own that item" do
        session[:user_id] = current_user
        queue_item = Fabricate(:queue_item, user: alice)
        delete :destroy, params: { id: queue_item.id }
        expect(alice.queue_items.count).to eq(1)
      end

      it "redirects to log in page for unauthenticated users" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, params: { id: queue_item.id }
        expect(response).to redirect_to login_path
      end
    end
  end

  context "with unauthenticated user" do
    describe "GET index" do
      it "redirects to log in page" do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
end
