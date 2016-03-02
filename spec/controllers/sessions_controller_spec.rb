require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { build(:user) }

  describe "GET #create" do
    context "when using github authentication" do
      context "is successful" do
        before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github] }

        it "redirects to the home page" do
          get :create, provider: :github
          expect(response).to redirect_to user_path(1)
        end

        it "creates a user" do
          expect { get :create, provider: :github }.to change(User, :count).by(1)
        end

        it "doesn't create a new user if user already exists" do
          User.create(uid: "123545", provider: "github", username: "Logan")
          expect { get :create, provider: :github }.to change(User, :count).by(0)
        end

        it "assigns the session[:user_id]" do
          get :create, provider: :github
          expect(session[:user_id]).to eq assigns(:user).id
        end

        it "logs out" do 
          delete :destroy
          expect(session[:user_id]).to eq nil
        end
      end
    end

    context "when using twitter authentication" do
      context "is successful" do
        before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] }

        it "redirects to the home page" do
          get :create, provider: :twitter
          expect(response).to redirect_to user_path(1)
        end

        it "creates a user" do
          expect { get :create, provider: :twitter }.to change(User, :count).by(1)
        end

        it "doesn't create a new user if user already exists" do
          User.create(uid: "123545", provider: "twitter", username: "Logan")
          expect { get :create, provider: :twitter }.to change(User, :count).by(0)
        end

        it "assigns the session[:user_id]" do
          get :create, provider: :twitter
          expect(session[:user_id]).to eq assigns(:user).id
        end

        it "logs out" do 
          delete :destroy
          expect(session[:user_id]).to eq nil
        end
      end
    end
  end
end
