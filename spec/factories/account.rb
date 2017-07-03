FactoryGirl.define do
  factory :account do
    balance { Faker::Number.between(-150.00, 1_000.00) }

    factory :account_created_yesterday do
      created_at 1.day.ago
    end
  end
end
