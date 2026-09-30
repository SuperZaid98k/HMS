# app/models/contact_message.rb
class ContactMessage < ApplicationRecord
  validates :name, presence: true
  validates :contact_no, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }

  # Default status if you added the status column
  attribute :status, :string, default: "unread"
end