class InvoiceItem < ApplicationRecord
    belongs_to :invoice, inverse_of: :invoice_items
end
