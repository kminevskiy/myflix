require "spec_helper"
require "rails_helper"

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }

  describe "#new_relationship?" do
    it "returns false if the relationship exists" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      Fabricate(:relationship, follower: user, leader: alice)
      expect(user.new_relationship?(alice.id)).to be false
    end

    it "returns true if it's a new relationship" do
      user = Fabricate(:user)
      alice = Fabricate(:user)
      expect(user.new_relationship?(alice.id)).to be true
    end
  end
end
