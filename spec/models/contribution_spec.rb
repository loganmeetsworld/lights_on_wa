require 'rails_helper'

RSpec.describe Contribution, type: :model do
  describe "#self.save_csvs(url)" do 
    it "saves a new csv" do 
      url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=SU5TTEogIDExMA====&year=2016&tab=contributions&type=statewide&page=1&orderBy=&groupBy=&filterBy="
      expect(Dir["csvs/**/*"].length).to eq 10597
    end
  end

  describe "#self.read_out_csvs(ids)" do 
    it "creates new csv" do 
    end
  end

  describe "#self.collect_csvs" do 
    it "" do 
    end

    it "" do 
    end
  end

  describe "#self.parse_csv" do 
    it "" do 
    end

    it "" do 
    end
  end

  describe "#self.cron_job" do 
    it "" do 
    end

    it "" do 
    end
  end
end
