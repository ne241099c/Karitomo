class ReservationsController < ApplicationController
  before_action :logged_in_member

  def index
    @reservations = Reservation.where("member_id = ? OR target_member_id = ?", current_member.id, current_member.id)
                               .order(start_at: :desc)

    if params[:sort] == "status"
      @reservations = @reservations.order(:status)
    elsif params[:sort] == "date_asc"
      @reservations = @reservations.reorder(start_at: :asc)
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
    
    unless @reservation.member_id == current_member.id || @reservation.target_member_id == current_member.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
      return
    end

    @reservation.update_status_if_completed

    flash.now[:success] = "予約が完了しました！" if params[:created]
  end

  def confirm
    @reservation = current_member.reservations.build(reservation_params)
    @target_member = Member.find(reservation_params[:target_member_id])

    if @reservation.invalid?(:create)
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
      redirect_to member_path(@target_member)
    end
  end

  def update_status
    @reservation = Reservation.find(params[:id])

    if @reservation.target_member_id != current_member.id
      flash[:alert] = "操作権限がありません"
      return redirect_to reservation_path(@reservation)
    end

    if @reservation.update(status: params[:status])
      redirect_to reservation_path(@reservation), notice: "ステータスを更新しました", status: :see_other
    else
      redirect_to reservation_path(@reservation), alert: "更新できませんでした: " + @reservation.errors.full_messages.join("、"), status: :see_other
    end
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