# db/seeds/development/z_associations.rb

puts "結びつきとスケジュールのシードデータを作成中..."

members = Member.order(:id)
regions = Region.all
tags = Tag.all
days = %w(月 火 水 木 金 土 日)

# ==========================================
# 1. リージョンとタグのランダムな結びつき
# ==========================================
members.each do |member|
  member.regions = regions.sample(rand(1..3))
  member.tags = tags.sample(rand(1..5))
  member.save!
end

# ==========================================
# 2. スケジュールの作成 (FreeDate)
# ==========================================
FreeDate.destroy_all

# --- 最初のメンバー: 全ての曜日の全ての時間 (ID:1 佐藤 太郎) ---
first_member = members.first
if first_member
  puts "  Member ID: #{first_member.id} (#{first_member.name}) -> 24時間365日稼働"
  days.each do |day|
    (0..23).each do |hour|
      FreeDate.create!(
        member: first_member,
        day: day,
        free_hour: Time.zone.parse("#{hour}:00")
      )
    end
  end
end

# --- 2番目のメンバー: ランダムな時間 ---
second_member = members.second
if second_member
  puts "  Member ID: #{second_member.id} (#{second_member.name}) -> ランダム稼働"
  days.each do |day|
    random_hours = (0..23).to_a.sample(rand(5..10))
    random_hours.sort.each do |hour|
      FreeDate.create!(
        member: second_member,
        day: day,
        free_hour: Time.zone.parse("#{hour}:00")
      )
    end
  end
end

# ==========================================
# 3. 追加データの生成 (予約・ブックマーク・ブロック等)
# ==========================================
puts "追加データを生成中..."

Bookmark.destroy_all
BlockedMember.destroy_all
Reservation.destroy_all
Review.destroy_all
Report.destroy_all

puts "特定のテスト用データを生成中..."

# 0番目のメンバー（佐藤 太郎）と相手役（鈴木 次郎）
taro = Member.find_by(name: "佐藤 太郎")
jiro = Member.find_by(name: "鈴木 次郎")

if taro && jiro
  # 評価待ちを再現する completed 予約（Review を作らない）
  past_date = 5.days.ago.beginning_of_day + 13.hours

  Reservation.create!(
    member: taro,
    target_member: jiro,
    start_at: past_date,
    hours: 1,
    status: :completed
  )
  puts "  佐藤 太郎さんの『評価待ち』予約データを作成しました。"
end

special_members = Member.where(special_member: true)
regular_members = Member.where(special_member: false)

# 3-1. ブックマークとブロック
regular_members.each do |m|
  m.bookmarked_members << special_members.sample(rand(2..3))
  m.blocking_members << special_members.sample if rand(1..5) == 1
end

# 3-2. 過去の予約（完了済み）
puts "  過去の予約とレビューを作成中..."
3.times do |i|
  member = regular_members.sample
  # 確実に予約を成功させるため、24時間稼働の最初の一人をターゲットにする
  target = first_member
  
  # 過去の日付 (7〜9日前)
  past_date = (7 + i).days.ago.beginning_of_day + 10.hours
  
  # --- 修正箇所: start_at と hours を追加 ---
  reservation = Reservation.create!(
    member: member,
    target_member: target,
    start_at: past_date,
    hours: 2,
    status: :completed
  )
  # ---------------------------------------

  Review.create!(
    reservation: reservation,
    score: rand(3..5),
    content: "先日はありがとうございました。#{i+1}回目の利用ですがいつも助かります。"
  )

  Chat.create!(reservation: reservation, member: member, content: "よろしくお願いします。")
  Chat.create!(reservation: reservation, member: target, content: "承知いたしました。")
end

# 3-3. 現在進行中・未来の予約と通報
puts "  進行中の予約と通報を作成中..."
active_res = Reservation.create!(
  member: regular_members.first,
  target_member: first_member,
  start_at: 1.day.from_now.beginning_of_day + 14.hours,
  hours: 1,
  status: :approved
)

# 通報データを作成 (通報者が member_id になっていることを確認)
Report.create!(
  reservation: active_res,
  member: regular_members.first,
  content: "チャット内で少し気になる発言がありました。念のため報告します。"
)

puts "全てのシードデータの作成が完了しました。"