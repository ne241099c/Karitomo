class Chat < ApplicationRecord
  belongs_to :reservation
  belongs_to :member

  validates :content, presence: true
end