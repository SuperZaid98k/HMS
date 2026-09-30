class Patient < ApplicationRecord
    validates :patient_number, presence: true
    belongs_to :user, optional: true
    has_one :patient_profile , dependent: :destroy
    accepts_nested_attributes_for :patient_profile, allow_destroy: true, update_only: true
    has_many :appointments
    has_many :doctor_profiles, through: :appointments
    has_many :admissions , dependent: :destroy
    has_many :medical_records , dependent: :destroy
    has_many :lab_tests, dependent: :destroy
    has_many :prescriptions, dependent: :destroy
    has_many :invoices, dependent: :destroy
    has_one :insurance_policy, dependent: :destroy
    has_many :documents, as: :documentable
end
