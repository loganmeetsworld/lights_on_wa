Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, :fields => [:username], :uid_field => :username unless Rails.env.production?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user,repo,gist" 
end