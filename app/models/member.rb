class Member < ApplicationRecord
    has_secure_password

    has_many :member_tags, dependent: :destroy
    has_many :tags, through: :member_tags
	has_many :member_regions, dependent: :destroy
  	has_many :regions, through: :member_regions
  	has_many :free_dates, dependent: :destroy

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true
	validates :birthday, presence: true
	validates :sex, presence: true
	validates :comment, length: { maximum: 200 }

	validates :price_per_hour, presence: true, numericality: { greater_than: 0 }, if: :special_member?

	attr_accessor :free_candidates
	before_save :save_free_dates

	scope :search_name, ->(query) {
		if query.present?
		where("name LIKE ?", "%#{query}%")
		end
	}
	private
	def save_free_dates
      return if free_candidates.nil?

      self.free_dates.destroy_all

      free_candidates.each do |candidate|
        day, hour = candidate.split(":")
        
        time_val = Time.zone.parse("#{hour}:00")
        
        self.free_dates.build(day: day, free_hour: time_val)
      end
    end
end
