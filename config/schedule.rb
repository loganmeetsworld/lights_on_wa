set :output, "#{path}/log/daily_jobs.log"

every 1.day, :at => '11:20 am' do
  runner "Candidate.cron_job", environment: :production
end

every 1.day, :at => '11:22 am' do
  runner "Contribution.cron_job", environment: :production
end