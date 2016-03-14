require 'restclient'
require 'open-uri'
require 'csv'

def load_pages
  offices = ["sw_candidates", "leg_candidates", "jud_candidates"]
  pages = Array.new

  offices.each do |office|
    url = "http://www.pdc.wa.gov/MvcQuerySystem/Candidate/#{office}"

    page = Nokogiri::HTML(RestClient.get(url))
    years =  page.css('#YearList')[0].text.split("\r\n")

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
  return pages
end

def create_candidates
  pages = load_pages

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
            Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, office: office, office_type: "statewide",party: party, raised: raised, spent: spent, debt: debt)
          when "legislative"
            dist   = child.children[2].text
            office = child.children[3].text            
            pos    = child.children[4].text
            party  = child.children[5].text
            raised = child.children[6].text[1..-1].gsub(",", "").to_f
            spent  = child.children[7].text[1..-1].gsub(",", "").to_f
            debt   = child.children[8].text[1..-1].gsub(",", "").to_f
            Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, dist: dist, pos: pos, party: party, raised: raised, spent: spent, debt: debt, office: office, office_type: "legislative")
          when "judicial"
            office = child.children[2].text
            pos    = child.children[4].text
            raised = child.children[5].text[1..-1].gsub(",", "").to_f
            spent  = child.children[6].text[1..-1].gsub(",", "").to_f
            debt   = child.children[7].text[1..-1].gsub(",", "").to_f
            Candidate.create(pdc_id_year: pdc_id + year, pdc_id: pdc_id, name: name, year: year, office: office, pos: pos, office_type: "judicial", raised: raised, spent: spent, debt: debt)
          end
        end
      end
    end
  end
end

def parse_csv(file)
  encoding  = "ISO-8859-1"
  begin
    my_header = CSV.parse(open(file, "rb:#{encoding}")).drop(4).first # is read necessary here? 
    data      = CSV.parse(open(file, "rb:#{encoding}"), :headers => my_header).drop(5)
  rescue SocketError
    puts file
    puts "socket error"
  rescue CSV::MalformedCSVError
    puts file
    puts "rescued a malformed CSV"
  end
  return data
end

def create_contributions(dir)
  values = nil
  contribution_array = []
  expenditure_array = []

  Dir.foreach(dir) do |item|
    # csv_time = Time.now
    puts item
    next if item == '.' or item == '..' or item == '.DS_Store' or item == "old"

    key = nil
    election = nil

    csv = parse_csv(dir + item)

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

      candidate_id = Candidate.find_by(pdc_id_year: key + election).id

      if item.split("20")[1].split(/(\d+)/)[-1] == "expenditures"
        csv.each do |row|
          row[" State"] == " WA" ? instate = true : instate = false
          expenditure_hash = {
            name:         row["Name"],
            city:         row[" City"],
            state:        row[" State"],
            zip:          row[" Zip"],
            date:         row[" Date"],
            amount:       row[" Amount"],
            description:  row[" Description"],
            instate:      instate,
            candidate_id: candidate_id
          }
          expenditure_array.push(Expenditure.new(expenditure_hash))
        end
      else
        csv.each do |row|
          row[" State"] == " WA" ? instate = true : instate = false
          contribution_hash = {
            name:         row["Contributor"],
            city:         row[" City"],
            state:        row[" State"],
            zip:          row[" Zip"],
            employer:     row[" Employer"],
            occupation:   row[" Occupation"],
            date:         row[" Date"],
            amount:       row[" Amount"],
            description:  row[" Description"],
            cont_type:    item.split("20")[1].split(/(\d+)/)[-1],
            instate:      instate,
            candidate_id: candidate_id
          }
          contribution_array.push(Contribution.new(contribution_hash))
        end
      end
    end
  end  
  Expenditure.import(expenditure_array)
  Contribution.import(contribution_array)
end

candidate_time = Time.now
create_candidates()
puts "Total time for just candidates seeding: " + (Time.now - candidate_time).to_s

create_contributions('csvs/part1/')
create_contributions('csvs/part2/')
create_contributions('csvs/part3/')
create_contributions('csvs/part4/')
# create_contributions('csvs/all/')