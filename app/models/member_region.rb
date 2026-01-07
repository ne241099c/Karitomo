class MemberRegion < ApplicationRecord
  belongs_to :member
  belongs_to :region
end
