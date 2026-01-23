class Report < ApplicationRecord
	belongs_to :reservation
	belongs_to :member

	validates :content, presence: true, length: { maximum: 300, too_long: "は300文字以内で入力してください" }
end
