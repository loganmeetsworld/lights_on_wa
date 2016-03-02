require "factory_girl"
require "simplecov"
require "rails_helper"

SimpleCov.start do
  add_filter 'spec/'
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({:provider => 'github', :uid => '123545', info: {username: "Logan"}})
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({:provider => 'twitter', :uid => '123545', info: {nickname: "Logan"}})
  end
end
