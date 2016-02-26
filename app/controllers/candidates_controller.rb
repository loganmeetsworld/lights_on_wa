class CandidatesController < ApplicationController
  def show
    @candidate = Candidate.find(params[:id])
  end

  def save
    @candidate = Candidate.find(params[:id])
    if current_user
      if @candidate.users.include? current_user
        redirect_to :back, :flash => {:error => "Already saved this candidate"}
      else
        current_user.candidates << @candidate
        redirect_to :back, :flash => {:error => "Candidate saved"}
      end
    else
      redirect_to :login, :flash => {:error => "Login to save candidates"}
    end
  end
end
