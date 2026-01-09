class ReportsController < ApplicationController
	before_action :login_required

	def create
		@reservation = Reservation.find(params[:reservation_id])
		@report = @reservation.reports.build(report_params)
		@report.member = current_member

		if @report.save
			redirect_to reservation_path(@reservation), notice: "通報を送信しました。"
		else
			redirect_to reservation_path(@reservation), alert: "送信に失敗しました。"
		end
	end

	private

	def report_params
		params.require(:report).permit(:content)
	end
end