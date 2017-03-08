shared_examples "token generator" do
  it "generates a token" do
    expect(object.token).not_to be_nil
  end
end
