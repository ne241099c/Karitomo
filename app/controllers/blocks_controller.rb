class BlocksController < ApplicationController
	before_action :login_required
	
	def index
		@blocked_members = current_member.blocking_members
	end

	def create
		@target_member = Member.find(params[:member_id])
		current_member.blocking_members << @target_member
		redirect_to blocks_path, notice: "ブロックしました"
	rescue ActiveRecord::RecordInvalid
		redirect_to blocks_path, alert: "ブロックに失敗しました"
	end

	def destroy
		@target_member = Member.find(params[:member_id])
		block = current_member.active_blocks.find_by(blocked_id: @target_member.id)
		block&.destroy
		redirect_to blocks_path, notice: "ブロックを解除しました"
	end
end