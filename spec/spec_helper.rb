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
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited
    # to use the mock authentication hash.
    # A request to /auth/provider will redirect
    # immediately to /auth/provider/callback.

    OmniAuth.config.test_mode = true

    # The mock_auth configuration allows you to
    # set per-provider (or default) authentication
    # hashes to return during testing.

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({:provider => 'github', :uid => '123545', info: {username: "Logan"}})
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({:provider => 'twitter', :uid => '123545', info: {nickname: "Logan"}})
  end
end
