set :output, "#{path}/log/daily_jobs.log"

every 1.day, :at => '1:00 am' do
  runner "Candidate.cron_job", environment: :production
end

every 1.day, :at => '1:30 am' do
  runner "Contribution.cron_job", environment: :production
end