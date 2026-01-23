class TopController < ApplicationController
	def index
		if current_member
			@recommended_members = Member.where.not(id: current_member.id)
										  .where.not(id: current_member.blocking_members.select(:id))
										  .where(special_member: true)
										  .order("RANDOM()")
										  .limit(6)
		else
			@recommended_members = Member.where(special_member: true)
										  .order("RANDOM()")
										  .limit(6)
		end
	end
end
