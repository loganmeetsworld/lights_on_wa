set :output, "#{path}/log/daily_jobs.log"
env :PATH, ENV['PATH']

every 1.day, :at => '11:00 am' do
  runner "Candidate.cron_job"
end

every 1.day, :at => '11:30 am' do
  runner "Contribution.cron_job"
end