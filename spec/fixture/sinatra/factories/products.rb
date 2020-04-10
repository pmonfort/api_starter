FactoryBot.define do
  factory :product do
    first_day_on_market { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    name { Faker::Name.name }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end
