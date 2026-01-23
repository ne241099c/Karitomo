puts "地域データを作成中..."
prefectures = %w(茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県)

prefectures.each do |name|
  Region.find_or_create_by!(name: name)
end
puts "地域データ生成完了！"