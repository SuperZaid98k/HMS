class PrescriptionItem < ApplicationRecord
    validates :prescription_id, :medicine_id, presence: true
    belongs_to :prescription
    belongs_to :medicine
end
