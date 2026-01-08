class Admin::MembersController < Admin::BaseController
  def index
    @members = Member.order(:id)
  end

  def show
    @member = Member.find(params[:id])
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to admin_members_path, notice: "会員「#{@member.name}」を削除しました。"
  end
end