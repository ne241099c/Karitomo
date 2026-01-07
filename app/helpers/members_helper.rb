module MembersHelper
    def schedule_table_tag(member)
        free_schedule_set = member.free_dates.map { |fd| "#{fd.day}:#{fd.free_hour.hour}" }.to_set
    
        render "shared/schedule_table", member: member, free_schedule_set: free_schedule_set
    end
end