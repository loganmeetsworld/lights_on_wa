require 'open-uri'
require 'csv'

class Contribution < ActiveRecord::Base
  belongs_to :candidate
  validates :name, uniqueness: { scope: :date }

  def self.save_csvs(url)
    encoding  = "ISO-8859-1"
    begin
      url_data = open(url, "rb:#{encoding}").read()
      f = File.new("new_csvs/#{url.split("param=")[1].split("===")[0] + url.split("type=")[1].split("&")[0] + url.split("year=")[1].split("&")[0] + url.split("tab=")[1].split("&")[0]}", "w")

      f << url_data
    rescue SocketError
      puts "socket error"
    rescue CSV::MalformedCSVError
      puts "rescued a malformed CSV"
    end
  end

  def self.read_out_csvs(ids)
    contribution_types = ["contributions", "inkind"]
    contribution_types.each do |contribution_type|
      ids.each do |key, elections|
        elections.each do |election|
          url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=#{key}====&year=#{election[0]}&tab=#{contribution_type}&type=#{election[1]}&page=1&orderBy=&groupBy=&filterBy="

          csv = Contribution.save_csvs(url)
        end
      end
    end
  end

  def self.collect_csvs
    offices = ["sw_candidates", "leg_candidates", "jud_candidates"]
    new_ids = Hash.new {|h,k| h[k] = [] }
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

    pages.each do |page|
      page.css('td a:contains("Details")').each do |p|
        pdc_id = p['href'].split("param=")[1].split("===")[0]
        year   = p['href'].split("year=")[1].split("&")[0]
        type   = p['href'].split("type=")[1]
        new_ids[pdc_id] << [year, type]
      end
    end

    f = File.new("new_ids", "w")
    f << new_ids

    Contribution.read_out_csvs(eval(File.read("new_ids")))
  end

  def self.parse_csv(file)
    encoding  = "ISO-8859-1"
    begin
      my_header = CSV.parse(open(file, "rb:#{encoding}")).drop(4).first # is read necessary here? 
      data      = CSV.parse(open(file, "rb:#{encoding}"), :headers => my_header).drop(5)
    rescue SocketError
      puts "socket error"
    rescue CSV::MalformedCSVError
      puts file
      puts "rescued a malformed CSV"
    end
    return data
  end

  def self.cron_job
    Contribution.collect_csvs()
    values = nil
    contribution_array = []

    Dir.foreach('new_csvs/') do |item|
      next if item == '.' or item == '..' or item == '.DS_Store' or item == "old"
      puts item
      key = nil
      election = nil
      csv = parse_csv('new_csvs/' + item)

      if !(csv == nil)
        puts "not nil"
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

        candidate = Candidate.find_by(pdc_id_year: key + election)

        if candidate.nil? 
          puts "Broke because candidates doesn't exist: " + candidate
          break
        end

        if !(candidate.contributions.empty?)
          puts candidate
          latest_date = candidate.contributions.max_by {|obj| obj.date }.date
          puts latest_date
        else
          puts "some reason candidate doesn't have contributions"
          puts candidate
          puts candidate.contributions
          latest_date = "2000/1/1"
        end

        csv.each do |row|
          puts "Row's date " + row[" Date"]
          puts "Latest: " + latest_date
          if row[" Date"].to_date > latest_date.to_date
            row[" State"].include?("WA") ? instate = true : instate = false
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
              candidate_id: candidate.id
            }
        
            Contribution.create(contribution_hash)
          end
        end
      end
    end
    FileUtils.rm_rf(Dir.glob('new_csvs/*'))
  end
end
