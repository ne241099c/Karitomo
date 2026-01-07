class Reservation < ApplicationRecord
  belongs_to :member
  belongs_to :target_member, class_name: "Member"
  has_many :reserved_dates, dependent: :destroy

  validate :check_availability
  validates :start_at, presence: true
  validates :hours, presence: true, numericality: { greater_than: 0 }

  after_create :create_reserved_dates_records

  private

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
