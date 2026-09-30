class Prescription < ApplicationRecord
    validates :patient_id, :doctor_profile_id, :medical_record_id, presence: true
    
    belongs_to :patient
    belongs_to :doctor_profile
    belongs_to :medical_record, optional: true
    has_many :prescription_items, dependent: :destroy
    accepts_nested_attributes_for :prescription_items, allow_destroy: true, reject_if: :all_blank
    has_one :medical_entry, as: :entryable, touch: true
end
