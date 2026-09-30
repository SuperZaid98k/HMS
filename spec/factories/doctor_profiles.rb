# spec/factories/doctor_profiles.rb
FactoryBot.define do
  factory :doctor_profile do
    association :user, factory: [:user, :doctor]
    association :department
    name { Faker::Name.name }
    license_number { "LIC-#{SecureRandom.hex(4).upcase}" }
    experience_years { 5 }
  end
end