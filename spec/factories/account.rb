FactoryGirl.define do
  factory :account do
    balance { Faker::Number.between(-150.00, 1_000.00) }
  end
end
