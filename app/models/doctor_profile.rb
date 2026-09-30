class DoctorProfile < ApplicationRecord
    validates :license_number, presence: true
    belongs_to :user, optional: true
    belongs_to :department
    has_many :appointments 
    has_many :patients, through: :appointments
    has_many :medical_records , dependent: :destroy
    has_many :lab_tests, dependent: :destroy
    has_many :prescriptions, dependent: :destroy
    has_and_belongs_to_many :specializations
    has_many :documents, as: :documentable
    has_many :subordinates, class_name: "DoctorProfile", foreign_key: "mentor_id"
    belongs_to :mentor, class_name: "DoctorProfile", optional: true
end
