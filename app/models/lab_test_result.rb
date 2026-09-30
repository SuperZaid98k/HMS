class LabTestResult < ApplicationRecord
    validates :lab_test_id, presence: true
    validates :result, inclusion: {in: %w(positive negative), message:"%{value} is not a valid result"}

    belongs_to :lab_test
    has_one :medical_entry, as: :entryable, touch: true
end
