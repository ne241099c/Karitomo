all_tags = Tag.all
all_regions = Region.all

filename = "404姉さん.jpg"
image_path = Rails.root.join("db", "seeds", "development", filename)

# 共通の保存・画像アタッチ用メソッドを定義するとスッキリします
def create_member_with_image(member, image_path, filename)
  member.save!(validate: false)
  
  if File.exist?(image_path) && member.special_member?
    member.profile_image.attach(io: File.open(image_path), filename: filename, content_type: "image/jpeg")
  elsif !File.exist?(image_path)
    puts "Warning: #{image_path} not found."
  end
end

# 1. ループでの作成
10.times do |i|
  member = Member.new(
    name: "ユーザー#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password123",
    sex: [1, 2, 3, 4].sample,
    birthday: (20..40).to_a.sample.years.ago, 
    price_per_hour: 1000 * (i + 1),
    comment: "初めまして。よろしくお願いします！",
    special_member: (i % 2 == 0),
    is_banned: false
  )
  
  create_member_with_image(member, image_path, filename)
  
  member.regions = all_regions.sample(rand(1..[all_regions.size, 3].min))
  member.tags = all_tags.sample(rand(0..[all_tags.size, 10].min))
end

# 2. いとうたろう
taro = Member.new(
  name: "いとうたろう",
  email: "itou_taro@example.com",
  password: "password",
  sex: 1,
  birthday: 30.years.ago, 
  price_per_hour: 1000,
  comment: "いとうたろうです。",
  special_member: true,
  is_banned: false
)
create_member_with_image(taro, image_path, filename)
taro.regions = all_regions.sample(2)
taro.tags = all_tags.sample(3)

# 3. ハナコ
hanako = Member.new(
  name: "ハナコ",
  email: "hanako@example.com",
  password: "password",
  sex: 2,
  birthday: 25.years.ago, 
  price_per_hour: 1000,
  comment: "ハナコです。",
  special_member: true,
  is_banned: false
)
create_member_with_image(hanako, image_path, filename)
hanako.regions = all_regions.sample(2)
hanako.tags = all_tags.sample(3)