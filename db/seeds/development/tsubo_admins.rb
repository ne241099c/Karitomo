# db/seeds/development/admin.rb

puts "管理者ユーザーを作成中..."

# 既存の管理者を削除（再作成の場合）
Admin.destroy_all

# 管理者ユーザーを作成
admin = Admin.create!(
  name: "admin",
  password: "pass",
)

puts "✓ 管理者ユーザーを作成しました"
puts "  Name: #{admin.name}"
