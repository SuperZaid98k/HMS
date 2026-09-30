class MedicalRecord < ApplicationRecord
    validates :patient_id, :doctor_profile_id, :appointment_id, presence: true

    belongs_to :appointment
    belongs_to :patient
    belongs_to :doctor_profile
    has_one :prescription
    has_many :treatment_assignments
    has_many :documents, as: :documentable
end
