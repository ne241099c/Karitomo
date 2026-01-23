class Contact < ApplicationRecord
    belongs_to :member
    validates :message, presence: true, length: { maximum: 300, too_long: "は300文字以内で入力してください" }
end
