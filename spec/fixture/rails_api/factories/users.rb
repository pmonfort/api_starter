FactoryBot.define do
  factory :user do
    age { Faker::Number.number(digits: 2) }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    company { create(:company) }
    email { Faker::Internet.email }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    password { Faker::Internet.password }
  end
end
