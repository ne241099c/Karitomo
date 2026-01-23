3.times do |n|
  # 3日前、4日前、5日前の予約を作成
  past_date = (Date.current - (n + 3).days).to_time.change(hour: 12 + n)
  
  res = Reservation.new(
    member: Member.where(id: 6..10).sample,
    target_member: Member.where(id: 1..5).where(special_member: true, is_banned: false).sample,
    start_at: past_date,
    hours: 2,
    comment: "過去の完了済み予約テストデータ #{n + 1}",
    status: :completed
  )
  
  res.save!(validate: false)
end

res = Reservation.new(
  member: Member.find_by(name: "ハナコ"),
  target_member: Member.find_by(name: "いとうたろう"),
  start_at: Time.zone.local(2030, 1, 1).change(hour: 12),
  hours: 2,
  comment: "未来のデータ",
  status: :pending
)

res.save!(validate: false)

res = Reservation.new(
  member: Member.find_by(name: "ハナコ"),
  target_member: Member.find_by(name: "いとうたろう"),
  start_at: Time.zone.local(2010, 1, 1).change(hour: 12),
  hours: 2,
  comment: "過去のデータ",
  status: :completed
)
res.save!(validate: false)