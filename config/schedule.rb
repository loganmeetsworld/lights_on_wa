set :output, {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}

every 1000.minutes do
  runner "Candidate.cron_job"
end

every 40.minutes do
  runner "Contribution.cron_job"
end