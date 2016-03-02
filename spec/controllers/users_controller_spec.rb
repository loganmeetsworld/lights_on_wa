require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }
  
  describe "GET #show" do 
    it "successfully gets page" do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      get :show, id: user.id
      expect(response).to render_template :show
    end

    it "requires login for show page" do
      
    end

    it "understands users candidates relationship" do 
      user.candidates << candidate
      expect(user.candidates.length).to eq 1
    end
  end
end
