require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }

  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "GET #letsencrypt" do 
    it "renders the https page" do
      session[:user_id] = user.id
      get :letsencrypt
      expect(response).to be_successful
    end
  end

  describe "GET #index" do
    it "renders the index page" do
      session[:user_id] = user.id
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #data" do 
    it "succesfully gets page" do 
      session[:user_id] = user.id
      get :data
      expect(response).to be_successful
      expect(response.status).to eq 200
    end

    it "renders json" do 
      session[:user_id] = user.id
      get :data
      expect(response.body.class).to be String
    end
  end

  describe "GET #contributions_data" do 
    it "succesfully gets page" do 
      session[:user_id] = user.id
      get :contributions_data, id: candidate.id
      expect(response).to be_successful
      expect(response.status).to eq 200
    end

    it "renders json" do 
      session[:user_id] = user.id
      get :contributions_data, id: candidate.id
      expect(response.body.class).to be String
    end
  end

  describe "GET #expenditures_data" do 
    it "succesfully gets page" do 
      session[:user_id] = user.id
      get :expenditures_data, id: candidate.id
      expect(response).to be_successful
      expect(response.status).to eq 200
    end

    it "renders json" do 
      session[:user_id] = user.id
      get :expenditures_data, id: candidate.id
      expect(response.body.class).to be String
    end
  end

  describe "GET #show" do
    it "renders show view" do
      get :show, id: candidate.id
      expect(response).to render_template :show
    end
  end

  describe "GET #expenditures" do
    it "renders expenditures view" do
      get :expenditures, id: candidate.id
      expect(response).to render_template :expenditures
    end
  end

  describe "GET #line" do
    it "renders the line page" do
      session[:user_id] = user.id
      get :line, id: candidate.id,:format => 'js'
      expect(response).to render_template :line
    end
  end

  describe "GET #burst" do
    it "renders the burst page" do
      session[:user_id] = user.id
      get :burst, id: candidate.id,:format => 'js'
      expect(response).to render_template :burst
    end
  end
  
  describe "POST #save" do
    it "redirects to the candidate show page" do 
      session[:user_id] = user.id
      post :save, id: candidate.id
      expect(response).to redirect_to "where_i_came_from"
    end

    it "adds one candidate to user" do
      session[:user_id] = user.id
      post :save, id: candidate.id
      expect(user.candidates.length).to eq 1
    end
  end

  describe "DELETE #destroy" do
    it "deletes candidates from the users candidates" do
      user.candidates << candidate
      session[:user_id] = user.id
      delete :destroy, id: candidate.id

      expect(user.candidates.size).to eq 0
    end

    it "redirects to the candidates_path" do
      user.candidates << candidate
      session[:user_id] = user.id
      delete :destroy, id: candidate.id

      expect(response).to redirect_to "where_i_came_from"
    end
  end
end
