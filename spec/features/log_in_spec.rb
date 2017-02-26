require "spec_helper"
require "rails_helper"

feature "User logs in" do
  scenario "with existing user credentials" do
    alice = Fabricate(:user)
    log_in(alice)
    expect(page).to have_content(alice.full_name)
  end
end

