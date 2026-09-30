# spec/factories/patients.rb
FactoryBot.define do
  factory :patient do
    association :user
    patient_number { "PAT-#{SecureRandom.random_number(10000..99999)}" }
  end
end