require 'rubygems'
require 'open-uri'
require 'csv'

class Candidate < ActiveRecord::Base
  has_many :candidates_to_user
  has_many :users, through: :candidates_to_user
  has_many :contributions
  validates_presence_of :name, :pdc_id
  validates_uniqueness_of :pdc_id_year

  def self.search(query)
    where("name like ?", "%#{query}%") 
  end

  def self.format_name(name)
    name = name.split(' ')[1].titlecase + ' ' + name.split(' ')[-1] + ". " + name.split(' ')[0].titlecase
  end

  def self.unformat_name(name)
    name = name.split(' ')[0].titlecase + ' ' + name.split(' ')[1] + " " + name.split(' ')[-1].titlecase
  end
end
