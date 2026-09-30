class Department < ApplicationRecord
    validates :hospital_id, :name, presence: true

    belongs_to :hospital 
    has_many :doctor_profiles , dependent: :destroy
    has_many :staff_profiles , dependent: :destroy
end