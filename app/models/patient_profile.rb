class PatientProfile < ApplicationRecord
    validates :patient_id, :first_name, presence: true
    belongs_to :patient
    
end
