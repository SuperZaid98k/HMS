class Invoice < ApplicationRecord
    validates :patient_id, :invoice_number, presence: true
    validates :status, inclusion: {in: %w(paid due), message:"%{value} is not a valid status (paid or due)"}
    belongs_to :patient
    belongs_to :appointment, optional: true
    has_many :invoice_items, dependent: :destroy, inverse_of: :invoice
    accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: :all_blank
    has_many :payments, dependent: :destroy
    has_many :documents, as: :documentable
    before_validation :calculate_total_amount
    def calculate_total_amount
        active_items = invoice_items.reject(&:marked_for_destruction?)
        if active_items.any?
            self.total_amount = active_items.sum do |item|
                (item.quantity.presence || 1).to_f * item.amount.to_f
        end
        else
            self.total_amount ||= 0.0
        end
    end
end