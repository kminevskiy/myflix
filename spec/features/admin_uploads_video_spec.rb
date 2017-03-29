require "spec_helper"
require "rails_helper"

feature "Admin uploads the new video" do
  let(:admin) { Fabricate(:user, admin: true) }

  scenario "with valid credentials", :vcr do
    create_categories
    log_in(admin)
    visit new_admin_video_path
    fill_in "Title", with: "Test video"
    select "Comedy", from: "Category"
    fill_in "Description", with: "Test video description"
    attach_file "Large Cover", "public/tmp/monk_large.jpg"
    attach_file "Small Cover", "public/tmp/monk.jpg"
    click_button "Add Video"
    visit video_path(Video.last)
    expect(page).to have_content("Test video description")
  end
end
