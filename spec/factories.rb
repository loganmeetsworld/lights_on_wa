FactoryGirl.define do
  factory :expenditure do
    date Time.now
    amount 1
    candidate_id 1
    description "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    instate false
  end

  factory :user do
    username "test_user"
    uid "12345"
    provider "github"
    last_seen_at Time.now - 1
  end

  factory :candidate do
    name "obama"
    pdc_id "code"
    year "2000"
    pdc_id_year "code_2000"
    office "GOVERNOR"
    party "R"
    raised 300
    spent 50
    debt 0
    office_type "statewide"
  end

  factory :contribution do
    date Time.now
    amount 300
    candidate_id 1
    cont_type "inkind"
    name "BILL"
    city "SEATTLE"
    state "WA"
    instate true
    zip "98122"
    employer "MICROSOFT"
    occupation "CEO"
  end
end
