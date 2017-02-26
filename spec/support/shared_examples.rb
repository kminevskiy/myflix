shared_examples "requires authenticated user" do
  it "redirects to the login path" do
    destroy_session
    action
    expect(response).to redirect_to login_path
  end
end
