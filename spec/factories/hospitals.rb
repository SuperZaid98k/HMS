# spec/factories/hospitals.rb
FactoryBot.define do
  factory :hospital do
    name { "City" }
    phone {"0192837465"}
    registration_number {"123456"}
    email {"mohd12345@gmail.com"}
    address {"near masjid ismailpura"}
  end
end