require "spec_helper"
require "rails_helper"

describe UserSignup do
  describe "#sign_up" do
    context "successful user sign up" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }

      before do
        allow(StripeWrapper::Customer).to receive(:create) { customer }
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("123", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("123", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end
    end

    context "failed user sign up" do
      let(:customer) { double(:customer, successful?: false, error_message: "This is an error message") }

      before do
        allow(StripeWrapper::Customer).to receive(:create) { customer }
      end

      it "does not create a user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("123", nil)
        expect(User.count).to eq(0)
      end
    end
  end
end
