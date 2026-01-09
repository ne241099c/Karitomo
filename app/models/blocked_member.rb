class BlockedMember < ApplicationRecord
  	belongs_to :member
  	belongs_to :blocked, class_name: "Member"
end
