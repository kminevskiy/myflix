require "spec_helper"
require "rails_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    describe "email sending" do
      context "with valid input" do
        after { ActionMailer::Base.deliveries.clear }

        before do
          post :create, params: { user: Fabricate.attributes_for(:user) }
        end

        it_behaves_like "token generator" do
          let(:object) { Fabricate(:user) }
        end

        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the right recipient" do
          message = ActionMailer::Base.deliveries.last
          user = assigns(:user)
          expect(message.to).to eq([user.email])
        end

        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          user = assigns(:user)
          expect(message.body).to include(user.email)
        end
      end

      context "with invalid input" do
        it "does not send an email with invalid input" do
          existing_user = Fabricate(:user)
          post :create, params: { user: { email: existing_user.email, password: "12345678", full_name: "Test Name"} }
          messages = ActionMailer::Base.deliveries
          expect(messages.size).to eq(0)
        end
      end
    end

    context "with valid input" do
      before do
        post :create, params: { user: Fabricate.attributes_for(:user) }
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to login page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid input" do
      before do
        post :create, params: { user: { password: "testtest", full_name: "Test name" } }
      end

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "renders the registration form" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    let(:user) { Fabricate(:user) }

    context "with authenticated user" do
      before do
        session[:user_id] = user.id
        get :show, params: { id: user.token }
      end

      it "sets the user variable" do
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    context "with unauthenticated user" do
      before do
        get :show, params: { id: user.id }
      end

      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end
    end
  end
end
