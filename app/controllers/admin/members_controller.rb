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

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to [:admin, @member], notice: "会員情報を更新しました"
    else
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(
      :name, :email, :birthday, :sex, :comment, 
      :special_member, :price_per_hour
    )
  end
end