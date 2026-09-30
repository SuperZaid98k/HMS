class Room < ApplicationRecord
    validates :ward_id, presence: true
    belongs_to :ward
    has_many :beds , dependent: :destroy
end
