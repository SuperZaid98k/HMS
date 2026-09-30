class Bed < ApplicationRecord
    validates :room_id, :bed_number, presence: true 
    validates :status, inclusion: { in: %w(occupied free),
    message: "%{value} is not a valid status (occupied or free)" }
    belongs_to :room
    has_many :admissions
    has_many :patients, through: :admissions    
end
