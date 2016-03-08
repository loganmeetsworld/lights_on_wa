set :output, "#{path}/log/daily_jobs.log"

every 1.day, :at => '11:15 am' do
  runner "Candidate.cron_job"
end

every 1.day, :at => '11:17 am' do
  runner "Contribution.cron_job"
end