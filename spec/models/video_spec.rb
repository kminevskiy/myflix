require "spec_helper"
require "rails_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Test video", description: "Test video description", small_cover_url: "https://testvideo.com", large_cover_url: "http://testvideo.com")
    video.save
    found_video = Video.first
    expect(found_video.title).to eq("Test video")
  end

  it "belongs to category" do
    category = Category.create(name: "Fiction")
    video = Video.create(title: "Test video", category: category, description: "Test video description", small_cover_url: "https://testvideo.com", large_cover_url: "http://testvideo.com")

    expect(video.category).to eq(category)
  end

  it "failes save without a title" do
    video = Video.new(description: "Test video")
    expect(video.save).to be false
  end

  it "failes save without a description" do
    video = Video.new(title: "Test video")
    expect(video.save).to be false
  end

  it "requires title and description" do
    video = Video.new(title: "Test video", description: "Test video description")
    expect(video.save).to be true
  end

  describe "#search_by_title" do
    it "returns an empty array if nothing found" do
      Video.create(title: "Great video", description: "Description for test video 1")
      Video.create(title: "Excellent video", description: "Description for test video 2")

      videos = Video.search_by_title("non_existent_title")
      expect(videos.empty?).to be true
    end

    it "returns an empty array if no search criteria provided" do
      Video.create(title: "Great video", description: "Description for test video 1")
      Video.create(title: "Excellent video", description: "Description for test video 2")

      videos = Video.search_by_title
      expect(videos.empty?).to be true
    end

    it "returns an array of Video object if they match a search criteria" do
      great_video = Video.create(title: "Great video", description: "Description for test video 1")
      Video.create(title: "Excellent video", description: "Description for test video 2")

      videos = Video.search_by_title("great")
      expect(videos).to include(great_video)
    end

    it "returns an array of Video objects sorted by their creation date" do
      old_video = Video.create(title: "Great video", description: "Description for test video 1", created_at: 1.day.ago)
      new_video = Video.create(title: "Excellent video", description: "Description for test video 2")

      videos = Video.search_by_title("video")
      expect(videos).to eq([new_video, old_video])
    end

    it "returns an empty array if input is an empty string" do
      Video.create(title: "Great video", description: "Description for test video 1", created_at: 1.day.ago)
      Video.create(title: "Excellent video", description: "Description for test video 2")

      videos = Video.search_by_title("")
      expect(videos).to eq([])
    end

  end
end
