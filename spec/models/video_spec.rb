require "spec_helper"
require "rails_helper"

describe Video, :vcr do
  it "saves itself" do
    video = Fabricate(:video)
    expect(Video.first).to eq(video)
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

  describe "#video is in the queue?" do
    it "returns true if video is in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(video.in_queue?(user.id)).to be(true)
    end

    it "returns false if video is not in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: Fabricate(:video), user: user)
      expect(video.in_queue?(user.id)).to be(false)
    end
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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        not_sun = Fabricate(:video, description: "something")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "filter with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }

      before do
        Fabricate(:review, rating: "2", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_2)
        Fabricate(:review, rating: "2", video: star_wars_3)
        refresh_index
      end

      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to match_array [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to match_array [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end
    end
  end
end
