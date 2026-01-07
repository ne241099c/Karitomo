module MembersHelper
    def schedule_table_tag(member)
        days = %w(月 火 水 木 金 土 日)
        # N+1対策: メンバーの空き時間をセットに格納して高速検索
        free_schedule_set = member.free_dates.map { |fd| "#{fd.day}:#{fd.free_hour.hour}" }.to_set

        content_tag(:table, class: "schedule-table") do
            concat(
                content_tag(:thead) do
                    content_tag(:tr) do
                        concat content_tag(:th, "時間")
                        days.each { |day| concat content_tag(:th, day) }
                    end
                end
            )

            concat(
                content_tag(:tbody) do
                    (0..23).each do |hour|
                        concat(
                            content_tag(:tr) do
                                concat content_tag(:th, "#{hour}:00")
                                days.each do |day|
                                    is_checked = free_schedule_set.include?("#{day}:#{hour}")
                                    concat(
                                        content_tag(:td) do
                                            check_box_tag "member[free_candidates][]", "#{day}:#{hour}", is_checked
                                        end
                                    )
                                end
                            end
                        )
                    end
                end
            )
        end
    end
end
