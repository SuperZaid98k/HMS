class Medicine < ApplicationRecord
    validates :name, presence: true
    has_many :prescription_items
end
