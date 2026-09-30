class HospitalRequest < ApplicationRecord
  VALID_STATUSES = %w[pending under_review approved rejected].freeze

  validates :hospital_name, :contact_person_name, :phone, :city, :address, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is an invalid email format" }
  validates :status, inclusion: { in: VALID_STATUSES }
  validates :total_beds, numericality: { greater_than: 0, allow_nil: true }

  scope :pending_requests, -> { where(status: "pending") }
end