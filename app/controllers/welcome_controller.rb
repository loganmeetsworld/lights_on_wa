class WelcomeController < ApplicationController
  def index
  end

  def search
    @candidates = Candidate.search(params[:search]).order("name DESC")
    respond_to do |format|
      format.js { render :nothing => true }
      format.html
    end
  end
end
