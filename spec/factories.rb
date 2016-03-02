FactoryGirl.define do
  factory :user do
    username "test_user"
    uid "12345"
    provider "github"
  end

  factory :candidate do
    name "obama"
    pdc_id "code"
    year "2000"
    pdc_id_year "code_2000"
    office "GOVERNOR"
    party "R"
    raised 100
    spent 50
    debt 0
    office_type "statewide"
  end

  factory :contribution do
    date "2000/04/01"
    amount 100
    candidate_id 1
    cont_type "inkind"
    name "BILL"
    city "SEATTLE"
    state "WA"
    zip "98122"
    employer "MICROSOFT"
    occupation "CEO"
  end
end
