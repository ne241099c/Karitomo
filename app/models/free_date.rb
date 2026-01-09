class FreeDate < ApplicationRecord
 	belongs_to :member
  	validates :free_hour, presence: true
end
