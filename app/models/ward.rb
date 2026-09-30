class Ward < ApplicationRecord
    validates :hospital_id, :name, presence: true
    belongs_to :hospital
    has_many :rooms , dependent: :destroy
end
