FactoryGirl.define do
  factory :transaction do
    description { Faker::Lorem.words(2).join(' ') }
    amount      { Faker::Number.between(-1_000.00, 1_000.00) }
    date        { Faker::Date.between(2.days.ago, Date.today) }
  end
end
