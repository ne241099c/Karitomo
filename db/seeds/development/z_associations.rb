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
  # ランダムに1〜3個の地域を割り当て
  member.regions = regions.sample(rand(1..3))
  
  # ランダムに1〜5個のタグを割り当て
  member.tags = tags.sample(rand(1..5))
  
  member.save!
end

# ==========================================
# 2. スケジュールの作成 (FreeDate)
# ==========================================
# 既存のスケジュールがあればクリア（重複防止）
FreeDate.where(member: [members.first, members.second]).destroy_all

# --- 最初のメンバー: 全ての曜日の全ての時間 ---
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
    # 1日あたり 5〜10個のランダムな時間枠を作成
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

puts "完了しました。"