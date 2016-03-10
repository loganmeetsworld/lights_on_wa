class CandidatesController < ApplicationController
  def index
    gon.candidates = Rails.cache.fetch('gon.candidates') do 
      Candidate.all
    end
  end

  def show
    @candidate = Candidate.find(params[:id])

    gon.contributions = Rails.cache.fetch("contributions_for_#{@candidate.pdc_id_year}") do 
      @candidate.contributions.where("amount > ?", 10)
    end

    gon.candidate_sunburst_data = Rails.cache.fetch("sunburst_for_#{@candidate.pdc_id_year}") do 
      Candidate.get_sunburst_data(@candidate)
    end
  end

  def line
    @candidate = Candidate.find(params[:id])
    @date_amounts = Candidate.create_date_hash(@candidate.contributions)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def burst    
    @candidate = Candidate.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def save
    @candidate = Candidate.find(params[:id])
    if current_user && !(current_user.candidates.include? @candidate)
      current_user.candidates << @candidate
      redirect_to :back, :flash => {:error => "Candidate saved to your account."}
    end
  end

  def destroy
    @candidate = current_user.candidates.find(params[:id])
    @candidate.save
    current_user.candidates.delete(@candidate)
    redirect_to :back, :flash => {:error => "Candidate removed from your account."}
  end
end
