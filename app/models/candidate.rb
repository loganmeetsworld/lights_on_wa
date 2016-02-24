require 'rubygems'
require 'open-uri'
require 'csv'

class Candidate < ActiveRecord::Base
  has_many :contributions
  has_and_belongs_to_many :elections
  validates_presence_of :name, :pdc_id
end
