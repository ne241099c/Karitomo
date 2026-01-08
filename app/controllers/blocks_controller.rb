class BlocksController < ApplicationController
    before_action :login_required

    def create
        @target_member = Member.find(params[:member_id])
        current_member.blocking_members << @target_member
        redirect_to member_path(@target_member), notice: "ブロックしました"
    rescue ActiveRecord::RecordInvalid
        redirect_to member_path(@target_member), alert: "ブロックに失敗しました"
    end

    def destroy
        @target_member = Member.find(params[:member_id])
        block = current_member.active_blocks.find_by(blocked_id: @target_member.id)
        block&.destroy
        redirect_to member_path(@target_member), notice: "ブロックを解除しました"
    end
end