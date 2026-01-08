class ReviewsController < ApplicationController
  before_action :login_required

  def create
    @reservation = Reservation.find(params[:reservation_id])
    
    unless @reservation.member_id == current_member.id && @reservation.completed?
      return redirect_to reservation_path(@reservation), alert: "レビューを投稿する権限がありません。"
    end

    @review = @reservation.build_review(review_params)
    if @review.save
      redirect_to reservation_path(@reservation), notice: "レビューを投稿しました。"
    else
      redirect_to reservation_path(@reservation), alert: "投稿に失敗しました。内容を確認してください。"
    end
  end

  private

  def review_params
    params.require(:review).permit(:score, :content)
  end
end