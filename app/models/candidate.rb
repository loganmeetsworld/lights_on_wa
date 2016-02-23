require 'rubygems'
require 'open-uri'
require 'csv'

class Candidate < ActiveRecord::Base
  has_many :contributions
  validates_presence_of :name, :cand_id
end
