# spec/factories/departments.rb
FactoryBot.define do
  factory :department do
    association :hospital
    name { "Cardiology" }
  end
end