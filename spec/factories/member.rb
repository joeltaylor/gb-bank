FactoryGirl.define do
  factory :member do
    name  { Faker::Name.name }
    email { Faker::Internet.unique.email}
  end
end
