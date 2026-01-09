class Admin::RegionsController < Admin::BaseController
	def index
		@regions = Region.all
	end

	def new
		@region = Region.new
	end

	def create
		@region = Region.new(region_params)
		if @region.save
			redirect_to admin_regions_path, notice: "地域「#{@region.name}」を追加しました"
		else
			render :new
		end
	end

	def edit
		@region = Region.find(params[:id])
	end

	def update
		@region = Region.find(params[:id])
		if @region.update(region_params)
			redirect_to admin_regions_path, notice: "地域を更新しました"
		else
			render :edit
		end
	end

	def destroy
		@region = Region.find(params[:id])
		@region.destroy
		redirect_to admin_regions_path, notice: "地域を削除しました"
	end

	private

	def region_params
		params.require(:region).permit(:name)
	end
end