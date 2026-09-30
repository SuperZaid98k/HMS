class LabTest < ApplicationRecord
    validates :patient_id, :doctor_profile_id, presence: true
    validates :status, inclusion: {in: %w(pending done), message:"%{value} is not a valid status"}
    has_one :lab_test_result, dependent: :destroy
    belongs_to :patient
    belongs_to :doctor_profile
end
