require "spec_helper"

feature "Admin sees payments" do
  let(:alice) { Fabricate(:user) }

  background do
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    admin = Fabricate(:user, admin: true)
    log_in(admin)
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content(alice.full_name)
    expect(page).to have_content(alice.email)
  end

  scenario "user cannot see payments" do
    user = Fabricate(:user)
    log_in(user)
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content(alice.full_name)
    expect(page).not_to have_content(alice.email)
  end
end
