require 'rails_helper'

RSpec.describe Contribution, type: :model do
  let(:candidate) { create(:candidate) }
  let(:contribution) { create(:contribution) }

  # describe "#self.save_csvs(url)" do 
  #   it "saves a new csv" do 
  #     url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=SU5TTEogIDExMA====&year=2016&tab=contributions&type=statewide&page=1&orderBy=&groupBy=&filterBy="
  #     expect(Dir["csvs/**/*"].length).to eq 10597
  #   end
  # end

  # describe "#self.cron_job()" do 
  #   it "empties new_csvs" do 
  #     Candidate.cron_job
  #     Contribution.cron_job
  #     expect(Dir["new_csvs/**/*"]).to eq []
  #   end
  # end
end
