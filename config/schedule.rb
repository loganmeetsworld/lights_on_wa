set :output, {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}

every 10.minutes do
  runner "Candidate.cron_job"
end

every 14.minutes do
  runner "Contribution.cron_job"
end