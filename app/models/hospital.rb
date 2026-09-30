class Hospital < ApplicationRecord
    validates :name, :phone, :registration_number, :email, presence: true
    validates :phone, length: { is: 10  }
    validates :email, format: { with:/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    message: "Invalid Email Format" }
    has_many :departments, dependent: :destroy
    has_many :wards, dependent: :destroy
    has_many :doctor_profiles, through: :departments 
end
