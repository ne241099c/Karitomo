class ReservationsController < ApplicationController
	before_action :logged_in_member

	def index
		@reservations = Reservation.where("member_id = ? OR target_member_id = ?", current_member.id, current_member.id).order(start_at: :desc)

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
		@dates = (Date.tomorrow..Date.tomorrow + 13.days).to_a

		if @reservation.invalid?(:create)
			flash.now[:alert] = "入力内容に不備があります: " + @reservation.errors.full_messages.join(", ")
			render 'new'
		else
			render 'confirm'
		end
	end

	def new
        @target_member = Member.find(params[:member_id])
        @reservation = current_member.reservations.build(target_member: @target_member)
        @dates = (Date.tomorrow..Date.tomorrow + 13.days).to_a
    end

	def create
		@target_member = Member.find(reservation_params[:target_member_id])
		@reservation = current_member.reservations.build(reservation_params)

		if @reservation.save
			redirect_to reservation_path(@reservation, created: true), notice: "予約が完了しました！"
		else
			@dates = (Date.tomorrow..Date.tomorrow + 13.days).to_a
			render :new
		end
	end

	def update_status
		@reservation = Reservation.find(params[:id])

		if @reservation.target_member_id != current_member.id
			flash[:alert] = "操作権限がありません"
			return redirect_to reservation_path(@reservation)
		end

		new_status = case params[:status]
					when 'approved' then 'approved_unpaid'
					when 'rejected' then 'rejected'
					when 'pending' then 'pending'
					else params[:status]
					end

		if @reservation.update(status: new_status)
			redirect_to reservation_path(@reservation), notice: "ステータスを更新しました", status: :see_other
		else
			redirect_to reservation_path(@reservation), alert: "更新できませんでした: " + @reservation.errors.full_messages.join("、"), status: :see_other
		end
	end

	def cancel
		@reservation = Reservation.find(params[:id])

		if @reservation.member_id != current_member.id
			flash[:alert] = "この予約をキャンセルする権限がありません"
			return redirect_to reservation_path(@reservation)
		end

		@reservation.admin_override = true
		if @reservation.update(status: :canceled)
			redirect_to reservations_path, notice: "予約をキャンセルしました", status: :see_other
		else
			flash[:alert] = "キャンセルできませんでした: " + @reservation.errors.full_messages.join(", ")
			return redirect_to reservation_path(@reservation)
		end
	end

	def pay
		@reservation = Reservation.find(params[:id])

		unless @reservation.member_id == current_member.id
			flash[:alert] = "この予約の支払い権限がありません"
			return redirect_to reservation_path(@reservation)
		end

		unless @reservation.approved_unpaid?
			flash[:alert] = "支払い可能な状態ではありません"
			return redirect_to reservation_path(@reservation)
		end

		if @reservation.update(status: :approved_paid)
			redirect_to reservation_path(@reservation), notice: "支払いが完了しました", status: :see_other
		else
			redirect_to reservation_path(@reservation), alert: "支払い処理に失敗しました: " + @reservation.errors.full_messages.join("、"), status: :see_other
		end
	end

  	private

	def reservation_params
		params.require(:reservation).permit(:target_member_id, :start_at, :hours, :comment)
	end
	
	def logged_in_member
		unless current_member.present?
			flash[:danger] = "ログインしてください"
			redirect_to login_url
		end
  	end
end