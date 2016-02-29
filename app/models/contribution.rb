class Contribution < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :contributor

  validates :name, uniqueness: { scope: [:date, :cont_type, :candidate_id, :amount, :city, :state] }

  

  def cron_scrape_pdc
    
  end
end
