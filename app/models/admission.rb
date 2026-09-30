class Admission < ApplicationRecord
    validates :patient_id, :bed_id, presence: true
    validates :status, inclusion:{in: %w(admitted discharged),message: "%{value} is not a valid status (admitted or discharged)"}
    belongs_to :patient
    belongs_to :bed

end
