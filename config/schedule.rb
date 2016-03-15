set :output, "#{path}/log/daily_jobs.log"
env :PATH, ENV['PATH']

every 1.day, :at => '2:40 pm' do
  runner "Candidate.cron_job"
end

every 1.day, :at => '2:45 pm' do
  runner "Contribution.cron_job"
end