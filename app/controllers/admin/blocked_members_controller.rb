class Admin::BlockedMembersController < Admin::BaseController
	def index
		@blocked_members = BlockedMember.includes(:member, :blocked).order(created_at: :desc)
	end
end
