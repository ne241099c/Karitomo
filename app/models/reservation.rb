class Reservation < ApplicationRecord
  belongs_to :member
  belongs_to :target_member, class_name: "Member"
  has_many :reserved_dates, dependent: :destroy
  has_many :chats, dependent: :destroy

  enum status: { pending: 0, approved: 1, rejected: 2, completed: 3 }

  validate :check_availability, on: :create
  validates :start_at, presence: true
  validates :hours, presence: true, numericality: { greater_than: 0 }

  validate :check_blocking_status

  after_create :create_reserved_dates_records

  def end_at
    start_at + hours.hours
  end

  def update_status_if_completed
    if approved? && Time.current > end_at
      update(status: :completed)
    end
  end

  private

  def check_blocking_status
    if member.blocking?(target_member)
      errors.add(:base, "このユーザーはブロックしているため予約できません")
    end

    if target_member.blocking?(member)
      errors.add(:base, "このユーザーにブロックされているため予約できません")
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
    (0...hours).each do |i|
      current_time = start_at + i.hours
      reserved_dates.create!(
        target_member: target_member,
        date: current_time
      )
    end
  end
end
