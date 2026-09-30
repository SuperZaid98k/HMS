class AppointmentNote < ApplicationRecord
    validates :appointment_id , presence: true
    belongs_to :appointment
end
