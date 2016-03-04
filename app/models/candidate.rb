require 'rubygems'
require 'open-uri'
require 'csv'

class Candidate < ActiveRecord::Base
  has_many :candidates_to_user
  has_many :users, through: :candidates_to_user
  has_many :contributions
  validates_presence_of :name, :pdc_id, :pdc_id_year
  validates_uniqueness_of :pdc_id_year

  def self.create_date_hash(contribution_objects)
    contribution_hash = Hash.new 0

    contribution_objects.each do |object|
      contribution_hash[object.date] += object.amount 
    end

    data = []
    total = 0
    contribution_hash = contribution_hash.sort

    contribution_hash.each do |k, v|
      data << {"date": "#{k[1..-1]}", "value": total}.as_json
      total += v.to_i
    end
    return data
  end

  def self.get_sunburst_data(candidate)
    candidate.contributions.where.not(state: " ").group_by { |v| v.instate }.map do |instate, contribution|
        {
          name: instate ? "IN STATE" : "OUT OF STATE",
          count: contribution.count,
          amount: contribution.inject(0){|sum,e| sum += e.amount },
          children: contribution.group_by{ |v| v.state }.map do |state, contribution|
            {
            name: state,
            count: contribution.count,
            amount: contribution.inject(0){|sum,e| sum += e.amount },
            children: contribution.group_by{ |v| v.city }.map do |city, contribution|
              {
                name: city,
                count: contribution.count,
                amount: contribution.inject(0){|sum,e| sum += e.amount },
                children: contribution.group_by{ |v| v.name }.map do |name, contribution|
                  {
                    name: name,
                    amount: contribution.inject(0){|sum,e| sum += e.amount },
                    count: contribution.count
                  }
                end
              }
            end
          }
        end
      }
    end
  end
end
