class Admin::ReservationsController < Admin::BaseController
  def index
    if params[:member_id]
      @member = Member.find(params[:member_id])
      @reservations = Reservation.where("member_id = ? OR target_member_id = ?", @member.id, @member.id)
                                 .order(start_at: :desc)
    else
      @reservations = Reservation.all.order(created_at: :desc)
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def chats
    @reservation = Reservation.find(params[:id])
    @chats = @reservation.chats.order(:created_at)
  end
end