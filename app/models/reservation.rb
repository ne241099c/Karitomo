class Reservation < ApplicationRecord
	belongs_to :member
	belongs_to :target_member, class_name: "Member"
	has_many :reserved_dates, dependent: :destroy
	has_many :chats, dependent: :destroy

	has_one :review, dependent: :destroy
	has_many :reports, dependent: :destroy

	enum status: { pending: 0, approved: 1, rejected: 2, completed: 3, canceled: 4 }

	attr_accessor :admin_override

	validate :check_availability, on: :create
	validates :start_at, presence: true
	validates :hours, presence: true, numericality: { greater_than: 0 }
	validates :comment, length: { maximum: 200 }

	validate :check_blocking_status
	validate :check_ban_status, on: :create
	validate :check_availability_on_revival, on: :update

	after_create :create_reserved_dates_records
	after_update :manage_reserved_dates_on_status_change

	validate :admin_only_canceled_change

	def end_at
		start_at + hours.hours
	end

	def update_status_if_completed
		if approved? && Time.current > end_at
			update(status: :completed)
		end
	end

	private

	def manage_reserved_dates_on_status_change
		return unless saved_change_to_status?

		if rejected? || canceled?
			reserved_dates.destroy_all
		elsif status_before_last_save == "rejected" || status_before_last_save == "canceled"
			create_reserved_dates_records
		end
	end

	def check_availability_on_revival
		if will_save_change_to_status? && status_was == "rejected" && !rejected?
			check_availability
		end
	end

	def admin_only_canceled_change
		return unless will_save_change_to_status?

		new_status = self.status
		prev_status = status_was

		if (new_status == "canceled" || prev_status == "canceled") && !admin_override
			errors.add(:status, "キャンセルの変更は管理者画面からのみ可能です")
		end
	end

	def check_blocking_status
		if member.blocking?(target_member)
			errors.add(:base, "このユーザーはブロックしているため予約できません")
		end

		if target_member.blocking?(member)
			errors.add(:base, "このユーザーにブロックされているため予約できません")
		end
	end

	def check_ban_status
		if member&.is_banned
			errors.add(:base, "あなたのアカウントはBANされているため予約できません")
		end
		if target_member&.is_banned
			errors.add(:base, "対象アカウントはBANされているため予約できません")
		end
	end

	def check_availability
		return unless start_at && hours && target_member

		(0...hours).each do |i|
			current_time = start_at + i.hours
			unless target_member.reservable?(current_time)
				errors.add(:base, "#{current_time.strftime('%m/%d %H:%M')} は予約できません")
			end
		end
	end

	def create_reserved_dates_records
		reserved_dates.destroy_all

		(0...hours).each do |i|
			current_time = start_at + i.hours
			reserved_dates.create!(
				target_member: target_member,
				date: current_time
			)
		end
	end
end