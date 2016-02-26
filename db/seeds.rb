# # Web scraper 
# require 'nokogiri'
# require 'restclient'
# require 'open-uri'
# require 'fileutils'
# require 'csv'

# # took out , "loc_candidates"
# offices = ["sw_candidates", "leg_candidates", "jud_candidates"]

# pages = Array.new

# offices.each do |office|
#   url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}"

#   page = Nokogiri::HTML(RestClient.get(url))
#   years =  page.css('#YearList')[0].text.split("\r\n")
#   puts url 

#   years.each do |year|
#     url_with_year = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}"
#     page_with_year = Nokogiri::HTML(RestClient.get(url_with_year))
#     num_pages = (page_with_year.css('.t-status-text').text.split(' ')[-1].to_i / 15.0).ceil
#     puts num_pages

#     (1..num_pages).to_a.each do |n|
#       page_url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}?year=#{year}&page=#{n}"
#       pages << Nokogiri::HTML(RestClient.get(page_url))
#     end
#   end
# end

# # ids now written to db
# # ids = Hash.new {|h,k| h[k] = [] }

# # pages.each do |page|
# #   page.css('td a:contains("Details")').each do |p|
# #     pdc_id = p['href'].split("param=")[1].split("===")[0]
# #     year   = p['href'].split("year=")[1].split("&")[0]
# #     type   = p['href'].split("type=")[1]
# #     ids[pdc_id] << [year, type]
# #   end
# # end

# # f = File.new("ids", "w")
# # f << ids

# pages.each do |page|
#   if !(page.css('tbody').children.last.text == "No records to display.")
#     page.css('tbody').children.each do |child|
#       if (child.children[0].children[0].attributes["href"].value.split("type=")[1] != nil)
#         pdc_id = child.children[0].children[0].attributes["href"].value.split("param=")[1].split("===")[0]
#         year   = child.children[0].children[0].attributes["href"].value.split("year=")[1].split("&")[0]
#         name   = child.children[1].text

#         case child.children[0].children[0].attributes["href"].value.split("type=")[1]
#         when "statewide"
#           office = child.children[2].text
#           party  = child.children[3].text
#           raised = child.children[4].text[1..-1].gsub(",", "").to_f
#           spent  = child.children[5].text[1..-1].gsub(",", "").to_f
#           debt   = child.children[6].text[1..-1].gsub(",", "").to_f
#           Candidate.create(pdc_id: pdc_id, name: name, year: year, office: office, party: party, raised: raised, spent: spent, debt: debt)
#         when "legislative"
#           dist   = child.children[2].text
#           pos    = child.children[3].text
#           party  = child.children[4].text
#           raised = child.children[5].text[1..-1].gsub(",", "").to_f
#           spent  = child.children[6].text[1..-1].gsub(",", "").to_f
#           debt   = child.children[7].text[1..-1].gsub(",", "").to_f
#           Candidate.create(pdc_id: pdc_id, name: name, year: year, dist: dist, pos: pos, party: party, raised: raised, spent: spent, debt: debt)
#         when "judicial"
#           court  = child.children[2].text
#           pos    = child.children[4].text
#           raised = child.children[5].text[1..-1].gsub(",", "").to_f
#           spent  = child.children[6].text[1..-1].gsub(",", "").to_f
#           debt   = child.children[7].text[1..-1].gsub(",", "").to_f
#           Candidate.create(pdc_id: pdc_id, name: name, year: year, court: court, pos: pos, raised: raised, spent: spent, debt: debt)
#         # when "local"
#         #   locality = child.children[2].text
#         #   office   = child.children[3].text
#         #   pos      = child.children[4].text
#         #   party    = child.children[5].text
#         #   raised   = child.children[6].text[1..-1].gsub(",", "").to_f
#         #   spent    = child.children[7].text[1..-1].gsub(",", "").to_f
#         #   debt     = child.children[8].text[1..-1].gsub(",", "").to_f
#         #   Candidate.create(pdc_id: pdc_id, name: name, year: year, locality: locality, office: office, pos: pos, party: party, raised: raised, spent: spent, debt: debt)
#         end
#       end
#     end
#   end
# end

# def save_csvs(url)
#   encoding  = "ISO-8859-1"
#   begin
#     url_data = open(url, "rb:#{encoding}").read()
#     f = File.new("csvs/#{url.split("param=")[1].split("===")[0] + url.split("type=")[1].split("&")[0] + url.split("year=")[1].split("&")[0] + url.split("tab=")[1].split("&")[0]}", "w")

#     f << url_data
#   rescue SocketError
#     puts "socket error"
#   rescue CSV::MalformedCSVError
#     puts "rescued a malformed CSV"
#   end
# end

# # 14406 times it goes through this loop
# def read_out_csvs(ids)
#   contribution_types = ["contributions", "inkind", "expenditures"]
#   contribution_types.each do |contribution_type|
#     ids.each do |key, elections|
#       elections.each do |election|
#         url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=#{key}====&year=#{election[0]}&tab=#{contribution_type}&type=#{election[1]}&page=1&orderBy=&groupBy=&filterBy="

#         puts url
#         puts contribution_type
#         puts key
#         puts election
#         csv = save_csvs(url)
#       end
#     end
#   end
# end

# read_out_csvs(eval(File.read("ids")))

require 'open-uri'

def parse_csv(file)
  encoding  = "ISO-8859-1"
  begin
    my_header = CSV.parse(open(file, "rb:#{encoding}").read).drop(4).first
    data      = CSV.parse(open(file, "rb:#{encoding}").read, :headers => my_header).drop(5)
  rescue SocketError
    puts "socket error"
  rescue CSV::MalformedCSVError
    puts "rescued a malformed CSV"
  end

  return data
end

def create_contributions(dir)
  Dir.foreach(dir) do |item|
    contribution_array = []
    
    next if item == '.' or item == '..' or item == '.DS_Store'
    puts item

    key = nil
    election = nil

    csv = parse_csv('csvs/' + item)
    if !(csv == nil)

      if item.split("statewide").length > 1
        key = item.split("statewide")[0]
        election = item.split("statewide")[1].split(/(\d+)/)[1]
      elsif item.split("legislative").length > 1
        key = item.split("legislative")[0]
        election = item.split("legislative")[1].split(/(\d+)/)[1]
      elsif item.split('judicial').length > 1
        key = item.split("judicial")[0]
        election = item.split("judicial")[1].split(/(\d+)/)[1]
      else
        puts "THIS WAS NIL"
        exit!
      end

      csv.each do |row|
        contribution_hash = {
          name:         row[0],
          city:         row[4],
          state:        row[5],
          zip:          row[6],
          employer:     row[7],
          occupation:   row[8],
          date:         row[1],
          amount:       row[2],
          description:  row[9],
          cont_type:    item.split("20")[1].split(/(\d+)/)[-1],
          candidate_id: Candidate.where(pdc_id: key, year: election)[0].id,
        }

        contribution_array.push(contribution_hash)
      end

      puts contribution_array.count
      puts key
      puts election
      puts item

      contribution_array.each do |cont|
        Contribution.create(cont)
      end
    end
  end
end

create_contributions('csvs/')