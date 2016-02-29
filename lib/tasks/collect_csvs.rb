require 'restclient'
require 'open-uri'
require 'csv'

def save_csvs(url)
  encoding  = "ISO-8859-1"
  begin
    url_data = open(url, "rb:#{encoding}").read()
    f = File.new("csvs/#{url.split("param=")[1].split("===")[0] + url.split("type=")[1].split("&")[0] + url.split("year=")[1].split("&")[0] + url.split("tab=")[1].split("&")[0]}", "w")

    f << url_data
  rescue SocketError
    puts "socket error"
  rescue CSV::MalformedCSVError
    puts "rescued a malformed CSV"
  end
end

def read_out_csvs(ids)
  contribution_types = ["contributions", "inkind", "expenditures"]
  contribution_types.each do |contribution_type|
    ids.each do |key, elections|
      elections.each do |election|
        url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/excel?param=#{key}====&year=#{election[0]}&tab=#{contribution_type}&type=#{election[1]}&page=1&orderBy=&groupBy=&filterBy="

        csv = save_csvs(url)
      end
    end
  end
end


read_out_csvs(eval(File.read("ids")))