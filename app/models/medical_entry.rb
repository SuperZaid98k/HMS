class MedicalEntry < ApplicationRecord
    delegated_type :entryable, types: %w[ Prescription LabTestResult ]
end
