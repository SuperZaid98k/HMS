# spec/models/invoice_spec.rb
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:patient) { create(:patient) }
  subject { build(:invoice, patient: patient) }

  describe "Associations" do
    it { should belong_to(:patient) }
    it { should belong_to(:appointment).optional }
    it { should have_many(:invoice_items).dependent(:destroy).inverse_of(:invoice) }
    it { should have_many(:payments).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of(:patient_id) }
    it { should validate_presence_of(:invoice_number) }
    
    # Matches your custom validation message in Invoice model
    it { should validate_inclusion_of(:status).in_array(%w[paid due]).with_message(/not a valid status/) }
  end

  describe "Callbacks: calculate_total_amount" do
    it "sums up (quantity * amount) across all active invoice items" do
      invoice = build(:invoice, patient: patient)
      invoice.invoice_items.build(description: "Consultation", quantity: 2, amount: 1500.0)
      invoice.invoice_items.build(description: "Blood Test", quantity: 1, amount: 500.0)

      invoice.save!

      expect(invoice.total_amount.to_f).to eq(3500.0)
    end

    it "defaults total_amount to 0.0 when no items are present" do
      invoice = create(:invoice, patient: patient)
      expect(invoice.total_amount.to_f).to eq(0.0)
    end
  end
end