set :output, {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}

every 1.day, :at => '1:00 am' do
  runner "Candidate.cron_job"
end

every 1.day, :at => '1:30 am' do
  runner "Contribution.cron_job"
end