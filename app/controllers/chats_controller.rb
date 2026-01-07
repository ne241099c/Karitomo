class ChatsController < ApplicationController
  before_action :login_required

  def index
    @reservation = Reservation.find(params[:reservation_id])
    
    unless @reservation.member_id == current_member.id || @reservation.target_member_id == current_member.id
      flash[:alert] = "権限がありません"
      redirect_to root_path
      return
    end

    @chats = @reservation.chats.order(:created_at)
    @chat = Chat.new
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    
    unless @reservation.member_id == current_member.id || @reservation.target_member_id == current_member.id
      head :forbidden
      return
    end

    @chat = @reservation.chats.build(chat_params)
    @chat.member = current_member

    if @chat.save
      ActionCable.server.broadcast("room_channel_#{@reservation.id}", {
        message: @chat.message,
        member_name: @chat.member.name,
        member_id: @chat.member.id,
        created_at: @chat.created_at.strftime("%H:%M"),
        is_current_user: false
      })
      head :ok
    else
      head :bad_request
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:content)
  end
end