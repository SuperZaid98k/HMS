class DoctorProfile < ApplicationRecord
  validates :license_number, presence: true

  belongs_to :user, optional: true
  belongs_to :department

  # Added dependent: :nullify (or :destroy depending on your business logic)
  has_many :appointments, dependent: :destroy
  has_many :patients, through: :appointments

  has_many :medical_records, dependent: :destroy
  has_many :lab_tests, dependent: :destroy
  has_many :prescriptions, dependent: :destroy
  has_and_belongs_to_many :specializations

  # Added dependent: :destroy so polymorphic records don't get orphaned
  has_many :documents, as: :documentable, dependent: :destroy

  # THE PRIMARY FIX: sets mentor_id to NULL on subordinate doctors before deleting this doctor
  has_many :subordinates, class_name: "DoctorProfile", foreign_key: "mentor_id", dependent: :nullify
  belongs_to :mentor, class_name: "DoctorProfile", optional: true
end