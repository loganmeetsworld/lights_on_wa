class Election < ActiveRecord::Base
  has_and_belongs_to_many :candidates
  validates_presence_of :name
end
