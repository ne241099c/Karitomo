class Bookmark < ApplicationRecord
  belongs_to :member
  belongs_to :bookmarked, class_name: "Member"
end
