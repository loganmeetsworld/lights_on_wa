FactoryGirl.define do
  factory :user do
    username "test_user"
    uid "12345"
    provider "github"
  end

  factory :candidate do
  end

  factory :contribution do
  end
end
