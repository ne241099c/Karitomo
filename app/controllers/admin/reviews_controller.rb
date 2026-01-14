class Admin::ReviewsController < Admin::BaseController
	def index
		@reviews = Review.includes(reservation: :member).order(created_at: :desc)
	end

	def destroy
		@review = Review.find(params[:id])
		@review.destroy
		redirect_to admin_reviews_path, notice: "評価を削除しました。"
	end
end