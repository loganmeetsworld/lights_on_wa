require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:candidate) { build(:candidate) }
  let(:contribution) { create(:contribution) }

  describe "validations" do
    it "creates a candidate instance when everything goes right" do
      expect(candidate).to be_valid
    end

    it "must have a name" do
      bad_candidate = candidate
      bad_candidate.name = nil
      expect(bad_candidate).to be_invalid
    end

    it "must have a pdc_id" do
      bad_candidate = candidate
      bad_candidate.pdc_id = nil
      expect(bad_candidate).to be_invalid
    end

    it "must have a pdc_id_year" do
      bad_candidate = candidate
      bad_candidate.pdc_id_year = nil
      expect(bad_candidate).to be_invalid
    end

    it "must have a unique pdc_id_year" do
      candidate.save
      bad_candidate = Candidate.new(name: "logan", pdc_id: "code", pdc_id_year: "code_2000")
      expect(bad_candidate.save).to eq false
    end
  end

  describe "self.create_date_hash(contribution_objects)" do 
    before(:each) do 
      candidate.save
      contribution.candidate_id = candidate.id
    end

    it "creates an array of hashes successfully" do
      date_amounts_array = Candidate.create_date_hash(candidate.contributions)
      expect(date_amounts_array).to be_an_instance_of Array
      expect(date_amounts_array.first).to be_an_instance_of Hash 
    end

    it "returns dates and amounts" do
      date_amounts_array = Candidate.create_date_hash(candidate.contributions)
      expect(date_amounts_array.first["date"]).to be_an_instance_of String
      expect(date_amounts_array.first["date"].to_date).to be_an_instance_of Date
      expect(date_amounts_array.first["value"]).to be_an_instance_of Fixnum
    end
  end

  describe "#self.get_sunburst_data(candidate)" do 
    before(:each) do 
      candidate.save
      contribution.candidate_id = candidate.id
    end

    let(:sunburst_array) { Candidate.get_sunburst_data(candidate) }

    it "creates an array of hashes successfully" do
      expect(sunburst_array).to be_an_instance_of Array
      expect(sunburst_array.first).to be_an_instance_of Hash 
    end

    it "produces whether in or out of state first level down in the hash" do
      expect(sunburst_array.first[:name]).to eq "OUT OF STATE" 
    end

    it "produces states second level down in the hash" do
      expect(sunburst_array.first[:children].first[:name]).to eq "WA" 
    end

    it "produces cities third level down in the hash" do
      expect(sunburst_array.first[:children].first[:children].first[:name]).to eq "SEATTLE" 
    end

    it "produces names third level down in the hash" do
      expect(sunburst_array.first[:children].first[:children].first[:children].first[:name]).to eq "BILL" 
    end
  end
end
