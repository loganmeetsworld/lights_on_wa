class Expenditure < ActiveRecord::Base
  belongs_to :candidate
  validates_uniqueness_of :name, scope: [:date, :amount]
end
