class Admin::ReservationsController < Admin::BaseController
  def index
    if params[:member_id]
      @member = Member.find(params[:member_id])
      @reservations = Reservation.where("member_id = ? OR target_member_id = ?", @member.id, @member.id)
    else
      @reservations = Reservation.all
    end
    
    # ソート処理
    if params[:sort] == "status"
      @reservations = @reservations.order(:status, start_at: :desc)
    elsif params[:sort] == "date_asc"
      @reservations = @reservations.order(start_at: :asc)
    else
      @reservations = @reservations.order(start_at: :desc)
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def chats
    @reservation = Reservation.find(params[:id])
    @chats = @reservation.chats.order(:created_at)
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.completed?
      redirect_to admin_reservation_path(@reservation), alert: "完了済みの予約はキャンセルできません。"
      return
    end

    @reservation.admin_override = true
    if @reservation.update(status: :canceled)
      redirect_to admin_reservation_path(@reservation), notice: "予約をキャンセルしました。"
    else
      redirect_to admin_reservation_path(@reservation), alert: @reservation.errors.full_messages.join("、")
    end
  end
end