class Member < ApplicationRecord
    has_secure_password

    has_many :member_tags, dependent: :destroy
    has_many :tags, through: :member_tags
	has_many :member_regions, dependent: :destroy
  	has_many :regions, through: :member_regions
  	has_many :free_dates, dependent: :destroy
	has_many :reservations, dependent: :destroy
	has_many :passive_reservations, class_name: "Reservation", foreign_key: "target_member_id", dependent: :destroy
	has_many :reserved_dates, foreign_key: "target_member_id", dependent: :destroy

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
		where("members.name LIKE ?", "%#{query}%")
		end
	}

	def reservable?(datetime)
		# FreeDateに含まれているか
		wday_str = %w(日 月 火 水 木 金 土)[datetime.wday]
		hour_val = datetime.hour
		
		is_free = free_dates.any? { |fd| fd.day == wday_str && fd.free_hour.hour == hour_val }
		return false unless is_free

		# すでに予約が入っていないか
		!reserved_dates.exists?(date: datetime)
  	end

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

	def reservable?(datetime)
    # 1. そもそもFreeDate（出勤可能日）に含まれているか？
    # 曜日の日本語変換 (%w(日 月 ...)[wday])
    wday_str = %w(日 月 火 水 木 金 土)[datetime.wday]
    hour_val = datetime.hour
    
    is_free = free_dates.any? { |fd| fd.day == wday_str && fd.free_hour.hour == hour_val }
    return false unless is_free

    # 2. すでに予約が入っていないか？ (ReservedDateになければOK)
    !reserved_dates.exists?(date: datetime)
  end
end
