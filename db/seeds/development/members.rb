# データの重複を防ぐため一度削除
Member.destroy_all

# 名前生成用の配列
fnames = ["佐藤", "鈴木", "高橋", "田中"]
gnames = ["太郎", "次郎", "花子"]

# 1. 日本語名のユーザーを10人作成
0.upto(9) do |idx|
  Member.create!(
    name: "#{fnames[idx % 4]} #{gnames[idx % 3]}", # 姓と名を結合して name カラムへ
    sex: [1, 1, 2][idx % 3],                        # 1:男性, 2:女性 と仮定して割り振り
    email: "member#{idx}@example.com",              # 一意になるようにインデックスを使用
    birthday: "1981-12-01",
    password: "asagao!",
    price_per_hour: 2000,
    comment: "こんにちは。#{idx}番目のメンバーです。",
    special_member: (idx % 2 == 0),                    # 最初の1人だけ特別会員(true)にする
    is_banned: false
  )
end

# 2. 英語名（John）のユーザーを20人作成
0.upto(19) do |idx|
  Member.create!(
    name: "John#{idx + 1}",
    sex: 1,                                         # 全員男性(1)とする
    email: "John#{idx + 1}@example.com",
    birthday: "1990-01-01",
    password: "asagao!",
    price_per_hour: 1500,
    comment: "Hello.",
    special_member: (idx % 2 == 0),
    is_banned: false
  )
end

puts "データの作成が完了しました。"