require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { build(:user) }
  let(:candidate) { create(:candidate) }
  let(:contribution) { build(:contribution) }
  let(:expenditure) { build(:expenditure) }

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

  describe "#self.notifcations" do 
    it "retrieves 0 when no notifcations" do
      user.save
      expect(User.notifications(user)).to eq 0
    end

    it "returns 0 if no contributions" do 
      user.save
      user.candidates << candidate
      expect(user.candidates.length).to eq 1
      expect(user.candidates.first.contributions.length).to eq 0
      expect(User.notifications(user)).to eq 0
    end

    it "returns lastest if expenditures exist" do 
      user.save
      expenditure.save
      user.candidates << candidate
      expect(user.candidates.length).to eq 1
      expect(user.candidates.first.expenditures.length).to eq 1
      expect(User.notifications(user)).to eq 0
    end

    it "retrieves notifications when there are some" do
      user.save
      user.candidates << candidate
      user.last_seen_at = "2016/1/1"
      contribution.save
      expect(user.candidates.length).to eq 1
      expect(user.candidates.first.contributions.length).to eq 1
      expect(User.notifications(user)).to eq 1
    end
  end
end
