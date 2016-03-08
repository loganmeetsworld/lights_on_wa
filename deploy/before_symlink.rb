run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile && bundle exec whenever --update-cron"
