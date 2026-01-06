class Member < ApplicationRecord
    has_secure_password

    has_many :member_tags, dependent: :destroy
    has_many :tags, through: :member_tags

    scope :search_name, ->(query) {
    if query.present?
      where("name LIKE ?", "%#{query}%")
    end
  }
end
