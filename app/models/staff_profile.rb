class StaffProfile < ApplicationRecord
    validates :employee_number, :department_id, presence: true
    validates :phone, length: { is: 10 }
    belongs_to :user, optional: true
    belongs_to :department
end
