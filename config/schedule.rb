set :output, "#{path}/log/daily_jobs.log"
env :PATH, ENV['PATH']

every 1.day, :at => '3:20 pm' do
  runner "Candidate.cron_job"
end

every 1.day, :at => '3:25 pm' do
  runner "Contribution.cron_job"
end