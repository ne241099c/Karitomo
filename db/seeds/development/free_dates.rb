puts "Creating free dates for all members..."
days_of_week = %w(月 火 水 木 金 土 日)

Member.all.each do |member|
  puts "  Creating free dates for #{member.name} (ID: #{member.id})"
  days_of_week.each do |day|
    (0..23).each do |h|
      FreeDate.create!(
        member_id: member.id,
        day: day,
        free_hour: Time.zone.parse("#{h}:00")
      )
    end
  end
end
puts "Free dates creation completed. Total: #{FreeDate.count}"