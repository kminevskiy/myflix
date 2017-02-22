require "spec_helper"
require "rails_helper"

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Matrix")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Matrix")
    end
  end

  describe "#average_rating" do
    it "returns the rating from the review if any reviews are present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "returns 0 if there are no reviews" do
      video = Fabricate(:video)
      user = Fabricate(:user)

      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category, name: "Comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Comedies")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: "Comedies")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end
