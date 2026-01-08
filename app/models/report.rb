class Report < ApplicationRecord
  belongs_to :reservation
  belongs_to :member

  validates :content, presence: true, length: { maximum: 1000 }
end
