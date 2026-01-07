class ReservationsController < ApplicationController
  before_action :logged_in_member

  def create
    @target_member = Member.find(params[:reservation][:target_member_id])
    @reservation = current_member.reservations.build(reservation_params)

    if @reservation.save
      flash[:success] = "予約が完了しました！"
      redirect_to member_path(@target_member)
    else
      flash[:alert] = "予約に失敗しました: " + @reservation.errors.full_messages.join(", ")
      redirect_to member_path(@target_member)
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:target_member_id, :start_at, :hours)
  end
  
  def logged_in_member
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end