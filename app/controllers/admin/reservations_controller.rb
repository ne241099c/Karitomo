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

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to admin_reservations_path, notice: "予約ID: #{@reservation.id} を削除しました。"
  end
end