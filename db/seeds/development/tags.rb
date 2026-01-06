tag_names = %w(
  Ruby
  Rails
  JavaScript
  TypeScript
  SQL
  Docker
  AWS
  初心者
  実務経験あり
  リモートワーク可
)

tag_names.each do |name|
  Tag.find_or_create_by!(name: name)
end

puts "タグデータの作成が完了しました。"

members = Member.all
tags = Tag.all

members.each do |member|
  tags_to_add = tags.sample(rand(0..3))
  
  member.tags = tags_to_add
end

puts "メンバーとタグの関連付けが完了しました。"