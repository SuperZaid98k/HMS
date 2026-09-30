class TreatmentAssignment < ApplicationRecord
    validates :medical_record_id, :treatment_id, presence: true

    belongs_to :treatment
    belongs_to :medical_record
end
