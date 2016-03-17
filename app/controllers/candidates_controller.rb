class CandidatesController < ApplicationController
  def letsencrypt
    render plain: ENV['LE_AUTH_RESPONSE']
  end

  def index
    gon.candidates = Candidate.all
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
    min = params[:offset].to_i + 1
    max = 1000
    contributions = candidate.contributions.order('amount DESC').offset(min).limit(max)

    if params[:offset].to_i <= candidate.contributions.length
      contributions_json = contributions.as_json
      render json: contributions_json
    else
      render json: [], status: 204
    end
  end

  def expenditures_data
    candidate = Candidate.find(params[:id])
    min = params[:offset].to_i + 1
    max = 1000
    expenditures = candidate.expenditures.order('amount DESC').offset(min).limit(max)

    if params[:offset].to_i <= candidate.expenditures.length
      expenditures_json = expenditures.as_json
      render json: expenditures_json
    else
      render json: [], status: 204
    end
  end

  def expenditures
    @candidate = Candidate.find(params[:id])
    gon.expenditures = @candidate.expenditures.order('amount DESC').first(10)
    gon.candidate_sunburst_data = Rails.cache.fetch(@candidate.pdc_id_year + "sunburst") do
      Candidate.get_sunburst_data(@candidate)
    end
  end

  def show
    @candidate = Candidate.find(params[:id])
    gon.contributions = @candidate.contributions.order('amount DESC').first
    gon.candidate_sunburst_data = Rails.cache.fetch(@candidate.pdc_id_year + "sunburst") do
      Candidate.get_sunburst_data(@candidate)
    end
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
