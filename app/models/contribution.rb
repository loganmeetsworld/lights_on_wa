class Contribution < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :contributor

  def cron_job
    ids = eval(File.read("ids"))
    ids.each do |key, elections|
      elections.each do |election|
        url = "http://www.pdc.wa.gov/MvcQuerySystem/CandidateData/contributions?param=#{key}%3D%3D%3D%3D&year=#{election[0]}&type=#{election[1]}&orderBy=date-desc"
        page = Nokogiri::HTML(RestClient.get(url))
        latest_date = Candidate.find_by(pdc_id_year: key + election[0]).contributions.max_by {|obj| obj.date }.date

        if !(page.css('tbody').children.last.text == "No records to display.")
          i = 0
          page_date = page.css('tbody').children[i].children[2].text
          while latest_date.to_date < Date.strptime(page_date, '%m/%d/%Y')
            name       = page.css('tbody').children[0].children[1].text
            date       = page.css('tbody').children[i].children[2].text
            amount     = page.css('tbody').children[i].children[3].text
            city       = page.css('tbody').children[i].children[5].text
            state      = page.css('tbody').children[i].children[6].text
            zip        = page.css('tbody').children[i].children[7].text
            employer   = page.css('tbody').children[i].children[8].text
            occupation = page.css('tbody').children[i].children[9].text

            Contribution.create(name: name, date: date, amount: amount, city: city, state: state, zip: zip, employer: employer, occupation: occupation)
            i += 1
          end
        end
      end
    end
  end
end
