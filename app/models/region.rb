class Region < ApplicationRecord
    has_many :member_regions, dependent: :destroy
    has_many :members, through: :member_regions
    validates :name, presence: true, uniqueness: true
end
