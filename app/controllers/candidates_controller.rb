class CandidatesController < ApplicationController
  def letsencrypt
    render plain: ENV['LE_AUTH_RESPONSE']
  end

  def index
    gon.candidates = Rails.cache.fetch('gon.candidates') do 
      Candidate.all
    end
  end

  def data
    candidates = Candidate.all
    min = params[:offset].to_i + 1
    max = min + params[:limit].to_i
    if params[:offset].to_i <= candidates.length
      candidate_json = candidates.where(:id => min..max).as_json
      render json: candidate_json
    else
      render json: [], status: 204
    end
  end

  def contributions_data
    candidate = Candidate.find(params[:id])
    contributions = candidate.contributions.order('amount DESC')
    min = params[:offset].to_i + 1
    max = min + 1000
    if params[:offset].to_i <= contributions.length
      contribution_json = contributions[min..max].as_json
      render json: contribution_json
    else
      render json: [], status: 204
    end
  end

  def show
    @candidate = Candidate.find(params[:id])
    # first_one = @candidate.contributions.length * 0.01

    gon.contributions = @candidate.contributions.order('amount DESC').first(10)

    gon.candidate_sunburst_data = Candidate.get_sunburst_data(@candidate)
  end

  def line
    @candidate = Candidate.find(params[:id])
    @date_amounts = Candidate.create_date_hash(@candidate.contributions)
    respond_to do |format|
      format.js
    end
  end

  def burst    
    @candidate = Candidate.find(params[:id])
    respond_to do |format|
      format.js
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
