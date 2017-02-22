require "spec_helper"
require "rails_helper"

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  it "has many videos" do
    category = Category.create(name: "Fiction")
    video = Video.create(title: "Test video", category: category, description: "Test video description", small_cover_url: "https://testvideo.com", large_cover_url: "http://testvideo.com")

    expect(category.videos).to include(video)
  end

  describe "#recent_videos" do
    it "returns last 6 videos (with 7 present) " do
      category = Category.create(name: "Fiction")
      7.times do |n|
        category.videos.create(title: "Test video #{n}", description: "Description for test video #{n}")
      end

    expect(category.recent_videos.size).to eq(6)
    end

    it "returns last 3 videos, in reverse chronological order" do
      category = Category.create(name: "Fiction")
      video1 = category.videos.create(title: "Test video 1", description: "Description for test video 1", created_at: 3.day.ago)
      video2 = category.videos.create(title: "Test video 2", description: "Description for test video 2", created_at: 2.day.ago)
      video3 = category.videos.create(title: "Test video 3", description: "Description for test video 3", created_at: 5.day.ago)

      expect(category.recent_videos).to eq([video2, video1, video3])
    end

    it "returns an empty array if category has no videos" do
      category = Category.create(name: "Fiction")

      expect(category.recent_videos).to eq([])
    end
  end
end
