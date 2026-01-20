class Contact < ApplicationRecord
    belongs_to :member
    validates :message, presence: true, length: { maximum: 300 }
end
