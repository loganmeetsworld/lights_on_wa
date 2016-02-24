# Web scraper 

require 'nokogiri'
require 'restclient'
require 'open-uri'
require 'fileutils'

offices = ["sw_candidates", "leg_candidates", "jud_candidates", "loc_candidates"]

pages = Array.new

offices.each do |office|
  url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}"

  page = Nokogiri::HTML(RestClient.get(url))
  years =  page.css('#YearList')[0].text.split("\r\n")

  years.each do |year|
    url_with_year = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}"
    page_with_year = Nokogiri::HTML(RestClient.get(url))
    num_pages = (page_with_year.css('.t-status-text').text.split(' ')[-1].to_i / 15.0).ceil

    (1..num_pages).to_a.each do |n|
      page_url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}&page=#{n}"

      puts page_url

      pages << Nokogiri::HTML(RestClient.get(page_url))
    end
  end
end

ids = Hash.new {|h,k| h[k] = Array.new }

pages.each do |page|
  page.css('td a:contains("Details")').each do |p|
    pdc_id = p['href'].split("param=")[1].split("===")[0]
    year   = p['href'].split("year=")[1].split("&")[0]
    type   = p['href'].split("type=")[1]
    ids[pdc_id] << [year, type]
  end
end

pages.each do |page|
  unless page.css('tbody').children.last.text == "No records to display."
    page.css('tbody').children.each do |child|
      pdc_id = child.children[0].children[0].attributes["href"].value.split("param=")[1].split("===")[0]
      puts pdc_id
      name = child.children[1].text
      year = child.children[0].children[0].attributes["href"].value.split("year=")[1].split("&")[0]
      Candidate.create(pdc_id: pdc_id, name: name, year: year)
    end
  end
end

def read_contributors(url)
  encoding = "ISO-8859-1"
  my_header = CSV.parse(open(url, "rb:#{encoding}").read).drop(4).first
  data = CSV.parse(open(url, "rb:#{encoding}").read, :headers => my_header).drop(5)
  return data
end


ids.each do |key, elections|
  elections.each do |election|
    url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=#{key}====&year=#{election[0]}&tab=contributions&type=#{election[1]}&page=1&orderBy=&groupBy=&filterBy="

    puts url

    contributor_array = []
    contribution_array = []
    csv = read_contributors(url)

    csv.each do |row|
      contributor_hash = {
        name: row[0],
        city: row[4], 
        state: row[5],
        zip: row[6],
        employer: row[7], 
        occupation: row[8], 
      }

      contributor_array.push(contributor_hash)
    end

    contributor_array.each do |cont|
      Contributor.create(cont)
    end

    csv.each do |row|
      contribution_hash = {
        date: row[1],
        amount: row[2],
        candidate_id: Candidate.where(pdc_id: key, year: election[0])[0].id,
        contributor_id: Contributor.find_by(name: row[0]).id
      }

      contribution_array.push(contribution_hash)
    end

    contribution_array.each do |cont|
      Contribution.create(cont)
    end
  end
end
