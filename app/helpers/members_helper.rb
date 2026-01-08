module MembersHelper
    def schedule_table_tag(member)
        checked_schedules = member.free_dates.map { |fd| "#{fd.day}:#{fd.free_hour.hour}" }.to_set

        schedule_info = {
            days: Member::DAYS_OF_WEEK,
            hours: Member::HOURS,
            checked_schedules: checked_schedules
        }
    
        render "shared/schedule_table", schedule_info: schedule_info
    end
end