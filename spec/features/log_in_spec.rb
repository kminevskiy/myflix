require "spec_helper"
require "rails_helper"

feature "User logs in" do
  scenario "with existing user credentials" do
    alice = Fabricate(:user)
    log_in(alice)
    expect(page).to have_content(alice.full_name)
  end

  scenario "with deactivated account" do
    alice = Fabricate(:user, active: false)
    log_in(alice)
    expect(page).not_to have_content(alice.full_name)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end

