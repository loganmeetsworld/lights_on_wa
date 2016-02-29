require 'restclient'
require 'open-uri'
require 'lib/read_ids.rb'

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
          Candidate.create(pdc_id: pdc_id, name: name, year: year, office: office, party: party, raised: raised, spent: spent, debt: debt)
        when "legislative"
          dist   = child.children[2].text
          pos    = child.children[3].text
          party  = child.children[4].text
          raised = child.children[5].text[1..-1].gsub(",", "").to_f
          spent  = child.children[6].text[1..-1].gsub(",", "").to_f
          debt   = child.children[7].text[1..-1].gsub(",", "").to_f
          Candidate.create(pdc_id: pdc_id, name: name, year: year, dist: dist, pos: pos, party: party, raised: raised, spent: spent, debt: debt)
        when "judicial"
          court  = child.children[2].text
          pos    = child.children[4].text
          raised = child.children[5].text[1..-1].gsub(",", "").to_f
          spent  = child.children[6].text[1..-1].gsub(",", "").to_f
          debt   = child.children[7].text[1..-1].gsub(",", "").to_f
          Candidate.create(pdc_id: pdc_id, name: name, year: year, court: court, pos: pos, raised: raised, spent: spent, debt: debt)
        # when "local"
        #   locality = child.children[2].text
        #   office   = child.children[3].text
        #   pos      = child.children[4].text
        #   party    = child.children[5].text
        #   raised   = child.children[6].text[1..-1].gsub(",", "").to_f
        #   spent    = child.children[7].text[1..-1].gsub(",", "").to_f
        #   debt     = child.children[8].text[1..-1].gsub(",", "").to_f
        #   Candidate.create(pdc_id: pdc_id, name: name, year: year, locality: locality, office: office, pos: pos, party: party, raised: raised, spent: spent, debt: debt)
        end
      end
    end
  end
end