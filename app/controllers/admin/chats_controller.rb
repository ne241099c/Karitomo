class Admin::ChatsController < Admin::BaseController
	def destroy
		@chat = Chat.find(params[:id])
		reservation = @chat.reservation
		@chat.destroy
		redirect_to chats_admin_reservation_path(reservation), notice: "メッセージを削除しました。"
	end
end