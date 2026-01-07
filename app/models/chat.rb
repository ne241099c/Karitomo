class Chat < ApplicationRecord
  belongs_to :reservation
  belongs_to :member

  validates :message, presence: true
end