class ReservationsController < ApplicationController
  before_action :logged_in_member

  def confirm
    @reservation = current_member.reservations.build(reservation_params)
    @target_member = Member.find(reservation_params[:target_member_id])

    if @reservation.invalid?
      flash[:alert] = "入力内容に不備があります: " + @reservation.errors.full_messages.join(", ")
      redirect_to member_path(@target_member)
    end
  end

  def create
    @target_member = Member.find(params[:reservation][:target_member_id])
    @reservation = current_member.reservations.build(reservation_params)

    if @reservation.save
      redirect_to reservation_path(@reservation, created: true)
    else
      flash[:alert] = "予約に失敗しました: " + @reservation.errors.full_messages.join(", ")
      redirect_to reservation_path(@reservation)
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
    flash.now[:success] = "予約が完了しました！" if params[:created]
  end

  private

  def reservation_params
    params.require(:reservation).permit(:target_member_id, :start_at, :hours)
  end
  
  def logged_in_member
    unless current_member.present?
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end