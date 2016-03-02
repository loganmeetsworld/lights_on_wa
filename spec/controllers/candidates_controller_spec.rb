require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }

  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "GET #index" do
    it "renders the index page" do
      session[:user_id] = user.id
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "renders show view" do
      get :show, id: candidate.id
      expect(response).to render_template :show
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
