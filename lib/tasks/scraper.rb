ids = eval(File.read("ids"))

def find_candidate_contacts(ids)
  ids.each do |key, elections|
    elections.each do |election|
      url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/contributions?param=#{key}====&year=#{election[0]}&type=#{election[1]}"

      candidate = Candidate.where(pdc_id: key, year: election[0]).first
      page = Nokogiri::HTML(RestClient.get(url))

      info = page.css(".t-window-content").text.gsub(" ","").split("\r\n").reject { |c| c.empty? }

      candidate.address = info[3]
      candidate.city    = info[5]
      candidate.state   = info[7]
      candidate.zip     = info[9]
      candidate.email   = info[11]
      candidate.phone   = info[13]
      candidate.save
    end
  end
end

find_candidate_contacts(ids)