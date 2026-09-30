class Appointment < ApplicationRecord
    validates :patient_id, :doctor_profile_id, presence: true
    belongs_to :patient
    belongs_to :doctor_profile
    has_one :medical_record
    has_many :invoices, dependent: :destroy
    has_many :appointment_notes
    has_many :documents, as: :documentable
end
