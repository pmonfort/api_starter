FactoryBot.define do
  factory :company do
    name { Faker::Name.name }
    web_site { Faker::Lorem.sentence }
  end
end
