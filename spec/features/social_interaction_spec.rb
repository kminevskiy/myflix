require "spec_helper"
require "rails_helper"

feature "User interacts with followers" do
  let(:user) { Fabricate(:user) }
  let(:alice) { Fabricate(:user) }
  let(:matrix) { Fabricate(:video) }

  scenario "by adding a follower", :vcr do
    Fabricate(:review, user: alice, video: matrix)
    log_in(user)
    visit video_path(matrix)
    click_link alice.full_name
    click_link "Follow"
    expect(page).to have_content(alice.full_name)
  end
end
