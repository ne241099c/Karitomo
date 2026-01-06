class Tag < ApplicationRecord
    has_many :member_tags, dependent: :destroy
    has_many :members, through: :member_tags
    validates :name, presence: true, uniqueness: true
end
