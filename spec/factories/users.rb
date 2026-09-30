# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { "patient" }

    trait :doctor do
      role { "doctor" }
    end

    trait :admin do
      role { "admin" }
    end

    trait :staff do
      role { "staff" }
    end
  end
end