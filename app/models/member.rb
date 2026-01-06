class Member < ApplicationRecord
    has_secure_password

    has_many :member_tags, dependent: :destroy
    has_many :tags, through: :member_tags
end
