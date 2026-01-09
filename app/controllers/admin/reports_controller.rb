class Admin::ReportsController < Admin::BaseController
  def index
    @reports = Report.includes(:member, :reservation).order(created_at: :desc)
  end

  def show
    @report = Report.find(params[:id])
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to admin_reports_path, notice: "通報記録を削除しました。"
  end
end