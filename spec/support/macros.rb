def set_videos_and_queue_items
  let(:video1) { Fabricate(:video) }
  let(:video2) { Fabricate(:video) }
  let(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user, video: video1, rating: 5) }
  let(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user, video: video2, rating: 4) }
end

def set_users
  let(:current_user) { Fabricate(:user) }
  let(:alice) { Fabricate(:user) }
end

def destroy_session
  session[:user_id] = nil
end
