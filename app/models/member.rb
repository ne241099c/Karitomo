class Member < ApplicationRecord
	DAYS_OF_WEEK = %w(月 火 水 木 金 土 日).freeze
    HOURS = 0..23
	
    has_secure_password

    has_many :member_tags, dependent: :destroy
    has_many :tags, through: :member_tags

	has_many :member_regions, dependent: :destroy
  	has_many :regions, through: :member_regions

  	has_many :free_dates, dependent: :destroy

	has_many :reservations, dependent: :destroy
	has_many :passive_reservations, class_name: "Reservation", foreign_key: "target_member_id", dependent: :destroy
	has_many :reserved_dates, foreign_key: "target_member_id", dependent: :destroy

	has_many :active_blocks, class_name: "BlockedMember", foreign_key: "member_id", dependent: :destroy
	has_many :blocking_members, through: :active_blocks, source: :blocked

	has_many :passive_blocks, class_name: "BlockedMember", foreign_key: "blocked_id", dependent: :destroy
	has_many :blockers, through: :passive_blocks, source: :member

	has_many :bookmarks, dependent: :destroy
	has_many :bookmarked_members, through: :bookmarks, source: :bookmarked

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true
	validates :birthday, presence: true
	validates :sex, presence: true
	validates :comment, length: { maximum: 200 }
	validates :password, presence: true, length: { minimum: 4 }

	validates :price_per_hour, presence: true, numericality: { greater_than: 0 }, if: :special_member?

	attr_accessor :free_candidates
	before_save :save_free_dates

	attr_accessor :current_password
	validates :current_password, presence: true, on: :update_password
  	validate :check_password, on: :update_password

	scope :search_name, ->(query) {
		if query.present?
		where("members.name LIKE ?", "%#{query}%")
		end
	}

	def reservable?(datetime)
		wday_index = (datetime.wday - 1) % 7
		wday_str = DAYS_OF_WEEK[wday_index]
		
		hour_val = datetime.hour
		
		is_free = free_dates.any? { |fd| fd.day == wday_str && fd.free_hour.hour == hour_val }
		return false unless is_free

		# すでに予約が入っていないか
		!reserved_dates.exists?(date: datetime)
  	end

	def blocking?(target_member)
   		blocking_members.include?(target_member)
  	end

	def bookmarked?(target_member)
		bookmarked_members.include?(target_member)
	end

	private

	def check_password
		if current_password.present? && !authenticate(current_password)
		errors.add(:current_password, :current_password_invalid)
		end
  	end

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
