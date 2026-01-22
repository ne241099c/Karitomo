class AccountsController < ApplicationController
	before_action :login_required, except: [:new, :create]
	before_action :prepare_master_data, only: [:new, :edit, :create, :update]

	def new
		@member = Member.new(birthday: Date.new(1980, 1, 1))
	end

	def show
		@member = current_member
	end

	def edit
		@member = current_member
	end

	def create
		@member = Member.new(member_params)
		if params[:next_step]
      		if @member.valid?
				render "step2"
			else
				render "new"
			end
		else
			if @member.valid?(:step2) && @member.save
				cookies_login(@member.id)
				redirect_to root_path, notice: "会員登録が完了しました"
			else
				render "step2"
			end
		end
	end

	def update
		@member = current_member
		@member.assign_attributes(member_params)
		if @member.valid?(:edit) && @member.save
			redirect_to account_path, notice: "アカウント情報を更新しました"
		else
			render :edit
		end
	end

	private

	def member_params
		params.require(:member).permit(
		:name, 
		:email, 
		:sex, 
		:birthday, 
		:comment, 
		:password, 
		:password_confirmation, 
		:special_member, 
		:price_per_hour,
		:profile_image,
		tag_ids: [], 
		region_ids: [], 
		free_candidates: []
		)
	end

	def prepare_master_data
		@tags = Tag.all
		@regions = Region.all
	end
end
