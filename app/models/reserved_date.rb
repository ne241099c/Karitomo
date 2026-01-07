class ReservedDate < ApplicationRecord
  belongs_to :reservation
  belongs_to :target_member
end
