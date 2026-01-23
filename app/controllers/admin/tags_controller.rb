class Admin::TagsController < Admin::BaseController
	def index
		@tags = Tag.all
		@tag = Tag.new
	end

	def new
		@tag = Tag.new
	end

	def create
		@tag = Tag.new(tag_params)
		if @tag.save
			redirect_to admin_tags_path, notice: "タグ「#{@tag.name}」を追加しました"
		else
			render :new
		end
	end

	def edit
		@tag = Tag.find(params[:id])
	end

	def update
		@tag = Tag.find(params[:id])
		if @tag.update(tag_params)
			redirect_to admin_tags_path, notice: "タグを更新しました"
		else
			render :edit
		end
	end

	def destroy
		@tag = Tag.find(params[:id])
		@tag.destroy
		redirect_to admin_tags_path, notice: "タグを削除しました"
	end

	private

	def tag_params
		params.require(:tag).permit(:name)
	end
end