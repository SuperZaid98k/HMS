class Document < ApplicationRecord
    validates :file_url, presence: true
    
    belongs_to :documentable, polymorphic: true
end
