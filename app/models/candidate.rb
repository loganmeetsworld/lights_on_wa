require 'rubygems'
require 'open-uri'
require 'csv'

class Candidate < ActiveRecord::Base
  has_many :candidates_to_user
  has_many :users, through: :candidates_to_user
  has_many :contributions
  validates_presence_of :name, :pdc_id, :pdc_id_year
  validates_uniqueness_of :pdc_id_year

  def self.load_pages
    offices = ["sw_candidates", "leg_candidates", "jud_candidates"]
    pages = Array.new

    offices.each do |office|
      url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}"

      page = Nokogiri::HTML(RestClient.get(url))
      years =  page.css('#YearList')[0].text.split("\r\n").select{|year| year.to_i >= Time.now.year}

      years.each do |year|
        url_with_year = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}"
        page_with_year = Nokogiri::HTML(RestClient.get(url_with_year))
        num_pages = (page_with_year.css('.t-status-text').text.split(' ')[-1].to_i / 15.0).ceil

        (1..num_pages).to_a.each do |n|
          page_url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}&page=#{n}"
          pages << Nokogiri::HTML(RestClient.get(page_url))
        end
      end
    end
    puts "LOADS IS WORKING"
    return pages
  end

  def self.cron_job
    pages = Candidate.load_pages()

    pages.each do |page|
      if !(page.css('tbody').children.last.text == "No records to display.")
        page.css('tbody').children.each do |child|
          if (child.children[0].children[0].attributes["href"].value.split("type=")[1] != nil)
            pdc_id = child.children[0].children[0].attributes["href"].value.split("param=")[1].split("===")[0]
            year   = child.children[0].children[0].attributes["href"].value.split("year=")[1].split("&")[0]
            name   = child.children[1].text

            case child.children[0].children[0].attributes["href"].value.split("type=")[1]
            when "statewide"
              office = child.children[2].text
              party  = child.children[3].text
              raised = child.children[4].text[1..-1].gsub(",", "").to_f
              spent  = child.children[5].text[1..-1].gsub(",", "").to_f
              debt   = child.children[6].text[1..-1].gsub(",", "").to_f
              c = Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, office: office, office_type: "statewide",party: party, raised: raised, spent: spent, debt: debt)
              if c.save 
                puts "Saved a new candidate: " + c.pdc_id_year
              end
            when "legislative"
              dist   = child.children[2].text
              office = child.children[3].text            
              pos    = child.children[4].text
              party  = child.children[5].text
              raised = child.children[6].text[1..-1].gsub(",", "").to_f
              spent  = child.children[7].text[1..-1].gsub(",", "").to_f
              debt   = child.children[8].text[1..-1].gsub(",", "").to_f
              c = Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, dist: dist, pos: pos, party: party, raised: raised, spent: spent, debt: debt, office: office, office_type: "legislative")
              if c.save 
                puts "Saved a new candidate: " + c.pdc_id_year
              end
            when "judicial"
              office = child.children[2].text
              pos    = child.children[4].text
              raised = child.children[5].text[1..-1].gsub(",", "").to_f
              spent  = child.children[6].text[1..-1].gsub(",", "").to_f
              debt   = child.children[7].text[1..-1].gsub(",", "").to_f
              c = Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, office: office, pos: pos, office_type: "judicial", raised: raised, spent: spent, debt: debt)
              if c.save 
                puts "Saved a new candidate: " + c.pdc_id_year
              end
            end
          end
        end
      end
    end
  end

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
          num_donations: contribution.count,
          count: contribution.inject(0){|sum,e| sum += e.amount },
          amount: contribution.inject(0){|sum,e| sum += e.amount },
          children: contribution.group_by{ |v| v.state }.map do |state, contribution|
            {
            name: state,
            num_donations: contribution.count,
            count: contribution.inject(0){|sum,e| sum += e.amount },
            amount: contribution.inject(0){|sum,e| sum += e.amount },
            children: contribution.group_by{ |v| v.city }.map do |city, contribution|
              {
                name: city,
                num_donations: contribution.count,
                count: contribution.inject(0){|sum,e| sum += e.amount },
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
