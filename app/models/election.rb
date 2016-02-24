class Election < ActiveRecord::Base
  has_and_belongs_to_many :candidates
  has_many :contributions
  validates_presence_of :name
end
