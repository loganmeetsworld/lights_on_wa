ids = eval(File.read("ids"))

def find_candidate_contacts(ids)
  ids.each do |key, elections|
    elections.each do |election|
      url = "https://www.pdc.wa.gov/MvcQuerySystem/CandidateData/contributions?param=#{key}====&year=#{election[0]}&type=#{election[1]}"

      candidate = Candidate.find_by(pdc_id_year: key + election[0])
      page = Nokogiri::HTML(RestClient.get(url))

      info = page.css(".t-window-content").text.gsub(" ","").split("\r\n").reject { |c| c.empty? }

      candidate.city    = info[5]
      candidate.state   = info[7]
      candidate.zip     = info[9].split('')[0..5].join('')
      candidate.save
    end
  end
end

def update_candidate_info(candidates)
  candidates.each do |candidate|
    if (candidate.name != nil) && (candidate.name != Candidate.unformat_name(candidate.name))
      candidate.name = Candidate.format_name(candidate.name)
    end
    if candidate.office != nil
      candidate.office = candidate.office.titlecase
    end
    candidate.save
  end
end

update_candidate_info(Candidate.all)
find_candidate_contacts(ids)