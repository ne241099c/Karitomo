class BookmarksController < ApplicationController
	before_action :login_required

	def index
		@bookmarked_members = current_member.bookmarked_members
	end

	def create
		@target_member = Member.find(params[:member_id])
		current_member.bookmarks.create(bookmarked_id: @target_member.id)
		redirect_to member_path(@target_member), notice: "ブックマークしました"
	end

	def destroy
		@target_member = Member.find(params[:member_id])
		bookmark = current_member.bookmarks.find_by(bookmarked_id: @target_member.id)
		bookmark&.destroy
		redirect_to member_path(@target_member), notice: "ブックマークを解除しました"
	end
end