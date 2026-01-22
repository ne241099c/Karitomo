Member.all.each do |member|
  (1..7).each do |w|
    (0..23).each do |h|
      FreeDate.create!(
        member_id: member.id,
        day: w.to_s,
        free_hour: Time.zone.parse("#{h}:00")
      )
    end
  end
end