FactoryGirl.define do
  factory :member do
    name  { Faker::Name.name }
    email { Faker::Internet.unique.email}

    factory :member_with_account do
      association :account, factory: :account_created_yesterday
    end
  end
end
