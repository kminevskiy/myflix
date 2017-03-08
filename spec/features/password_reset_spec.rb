require "spec_helper"
require "rails_helper"

feature "User resets password" do
  let(:user) { Fabricate(:user) }
  background do
    clear_emails
    visit reset_path
    fill_in "Email Address", with: user.email
    click_button "Reset password"
    open_email(user.email)
    current_email.click_link "Reset password"
  end

  scenario "following a link" do
    expect(page).to have_content("New Password")
  end

  scenario "reseting the password" do
    fill_in "New Password", with: "test1234"
    click_button "Reset password"
    log_in(user)
    expect(page).to have_content(user.full_name)
  end
end
