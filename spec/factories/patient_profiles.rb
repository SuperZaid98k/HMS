# spec/factories/patient_profiles.rb
FactoryBot.define do
  factory :patient_profile do
    association :patient
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    phone      { "+91 9876543210" }
    blood_group { "O+" }
  end
end