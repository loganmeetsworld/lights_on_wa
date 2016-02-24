class Contribution < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :contributor
  belongs_to :election
end
