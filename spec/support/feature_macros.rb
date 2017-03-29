def log_in(user=nil)
  current_user = user || Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: current_user.email
  fill_in "Password", with: current_user.password
  click_button "Sign in"
end

def create_categories
  Fabricate(:category, name: "Action")
  Fabricate(:category, name: "Comedy")
end

def fill_user_info
  fill_in "Email Address", with: "test@example.com"
  fill_in "Password", with: "test1234"
  fill_in "Full Name", with: "Test User"
end

