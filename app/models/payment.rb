class Payment < ApplicationRecord
    validates :invoice_id, presence: true
    validates :payment_method, inclusion: {in: %w(cash upi card), message:"%{value} is not a valid payment method (cash/upi/card)"}
    belongs_to :invoice
end
