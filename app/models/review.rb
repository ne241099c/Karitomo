class Review < ApplicationRecord
	belongs_to :reservation

	validates :score, presence: true, inclusion: { in: 1..5 }
	validates :content, presence: true, length: { maximum: 100, too_long: "は100文字以内で入力してください" }
end
