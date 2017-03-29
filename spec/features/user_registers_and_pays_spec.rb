require "spec_helper"
require "rails_helper"

=begin
feature "User registers and pays", js: true do
  scenario "with valid user info", driver: :webkit do
    visit register_path
    fill_user_info
    click_button "Sign Up"
    expect(page).to have_content("Sign Up")
  end
  scenario "with invalid user info"
end
=end
