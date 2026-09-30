# spec/factories/invoices.rb
FactoryBot.define do
  factory :invoice do
    # strategy: :create ensures patient gets an ID in the test database
    association :patient, factory: :patient, strategy: :create
    invoice_number { "INV-#{SecureRandom.random_number(100000..999999)}" }
    status { "due" }
    issued_at { Time.current }
  end

  factory :invoice_item do
    association :invoice
    description { "General Consultation" }
    quantity { 1 }
    amount { 500.0 }
  end
end