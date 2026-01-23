# データの重複を防ぐため一度削除
Member.destroy_all

filename = "404姉さん.jpg"
path = Rails.root.join(__dir__, filename)

# 名前生成用の配列
fnames = ["佐藤", "鈴木", "高橋", "田中"]
gnames = ["太郎", "次郎", "花子"]

# 1. 日本語名のユーザーを10人作成
0.upto(9) do |idx|
  m = Member.new(
    name: "#{fnames[idx % 4]} #{gnames[idx % 3]}", # 姓と名を結合して name カラムへ
    sex: [1, 1, 2][idx % 3],                        # 1:男性, 2:女性 と仮定して割り振り
    email: "member#{idx}@example.com",              # 一意になるようにインデックスを使用
    birthday: "1981-12-01",
    password: "password",
    price_per_hour: 2000,
    comment: "こんにちは。#{idx}番目のメンバーです。",
    special_member: (idx % 2 == 0),                    # 最初の1人だけ特別会員(true)にする
    is_banned: false
  )
  m.save!(validate: false)
  
  if File.exist?(path) && m.special_member?
    m.profile_image.attach(io: File.open(path), filename: filename, content_type: "image/jpeg")
  end
end

# 2. 英語名（John）のユーザーを20人作成
0.upto(19) do |idx|
  m = Member.new(
    name: "John#{idx + 1}",
    sex: 1,                                         # 全員男性(1)とする
    email: "John#{idx + 1}@example.com",
    birthday: "1990-01-01",
    password: "password",
    price_per_hour: 1500,
    comment: "Hello.",
    special_member: (idx % 2 == 0),
    is_banned: false
  )
  m.save!(validate: false)
  
  if File.exist?(path) && m.special_member?
    m.profile_image.attach(io: File.open(path), filename: filename, content_type: "image/jpeg")
  end
end

puts "メンバーデータの作成が完了しました。"