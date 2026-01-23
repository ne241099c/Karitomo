hanako = Member.find_by(name: "ハナコ")
taro = Member.find_by(name: "いとうたろう")

# 2030年1月1日の予約を取得
reservation = Reservation.where(
  member: hanako,
  target_member: taro,
  start_at: Time.zone.local(2030, 1, 1).change(hour: 12)
).first

if reservation.present?
  # ハナコのチャット
  Chat.create!(
    reservation: reservation,
    member: hanako,
    content: "こんにちは！2030年1月1日の予約についてお聞きしたいことがあります。"
  )
  
  Chat.create!(
    reservation: reservation,
    member: hanako,
    content: "当日の時間帯は確認していただけましたでしょうか？"
  )
  
  # いとうたろうのチャット
  Chat.create!(
    reservation: reservation,
    member: taro,
    content: "こんにちは、ハナコさん。ご確認ありがとうございます。"
  )
  
  Chat.create!(
    reservation: reservation,
    member: taro,
    content: "はい、1月1日の12時でしたね。了解いたしました。"
  )
  
  Chat.create!(
    reservation: reservation,
    member: taro,
    content: "何かご不明な点があればお気軽にお聞きください。"
  )
  
  # ハナコの返信
  Chat.create!(
    reservation: reservation,
    member: hanako,
    content: "ありがとうございます！安心しました。よろしくお願いします。"
  )
  
  puts "Chats created for 2030/1/1 reservation between ハナコ and いとうたろう"
else
  puts "Reservation not found for 2030/1/1 between ハナコ and いとうたろう"
end
