class Expenditure < ActiveRecord::Base
  belongs_to :candidate
  validates_uniqueness_of :vendor, scope: [:date, :amount]
end
