class CandidatesController < ApplicationController
  def index
    gon.candidates = Candidate.all
  end

  def show
    @candidate = Candidate.find(params[:id])
    gon.contributions = @candidate.contributions
  end

  def save
    @candidate = Candidate.find(params[:id])
    if current_user
      current_user.candidates << @candidate
      redirect_to :back, :flash => {:error => "Candidate saved to your account."}
    end
  end

  def destroy
    @candidate = current_user.candidates.find(params[:id])
    @candidate.save
    current_user.candidates.delete(@candidate)
    redirect_to :back
  end
end
