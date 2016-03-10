source 'https://rubygems.org'

# Necessary rails things
gem 'rails', '4.2.5.1'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bcrypt', '~> 3.1.7'

# Batching db instances
gem 'activerecord-import', '~> 0.11.0'

# Deployment
gem 'aws-sdk', '~> 2'
gem 'therubyracer', platforms: :ruby

# Javascript-ruby connections
gem 'gon'

# Cron jobs
gem 'whenever', :require => false

# Caching
gem 'dalli'

# Authentication
gem 'omniauth'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-github'
gem 'omniauth-twitter'

# Styling and behavioral
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 2.3.0'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'd3-rails'
gem 'metrics-graphics-rails'

# Web Scraping
gem 'crack', '~> 0.4.3'
gem 'rest-client', '~> 1.8'

group :production do
  gem 'mysql2', '~> 0.3.18'
  gem 'unicorn'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'sqlite3'
  gem 'byebug'
  gem 'rspec-rails'
  gem 'hirb'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'pry'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'spring'
end

