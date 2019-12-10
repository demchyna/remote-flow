FactoryBot.define do
  factory :device_group do
    name { Faker::Address.city }
    description { Faker::Lorem.paragraph }
    organization
  end
end
