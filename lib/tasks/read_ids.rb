require 'restclient'
require 'open-uri'

offices = ["sw_candidates", "leg_candidates", "jud_candidates"]

ids = Hash.new {|h,k| h[k] = [] }
pages = Array.new

offices.each do |office|
  url = "https://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}"

  page = Nokogiri::HTML(RestClient.get(url))
  years =  page.css('#YearList')[0].text.split("\r\n")
  puts url 

  years.each do |year|
    url_with_year = "https://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}"
    page_with_year = Nokogiri::HTML(RestClient.get(url_with_year))
    num_pages = (page_with_year.css('.t-status-text').text.split(' ')[-1].to_i / 15.0).ceil
    puts num_pages

    (1..num_pages).to_a.each do |n|
      page_url = "https://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}&page=#{n}"
      pages << Nokogiri::HTML(RestClient.get(page_url))
    end
  end
end

pages.each do |page|
  page.css('td a:contains("Details")').each do |p|
    pdc_id = p['href'].split("param=")[1].split("===")[0]
    year   = p['href'].split("year=")[1].split("&")[0]
    type   = p['href'].split("type=")[1]
    ids[pdc_id] << [year, type]
  end
end

f = File.new("ids", "w")
f << ids