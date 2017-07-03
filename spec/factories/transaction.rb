FactoryGirl.define do
  factory :transaction do
    description { Faker::Lorem.words(2).join(' ') }
    amount      { Faker::Number.between(-10.00, 10.00) }
    date        { Time.current }
    association :account, factory: :account_created_yesterday
  end
end
