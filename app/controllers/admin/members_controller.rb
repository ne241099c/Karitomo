class Admin::MembersController < Admin::BaseController
	def index
		@tags = Tag.all
		@regions = Region.all
		@members = Member.all
		
		# 検索処理
		if params[:search_name].present?
			@members = @members.search_name(params[:search_name])
		end

		selected_tag_ids = params[:tag_ids]&.compact_blank
		if selected_tag_ids.present?
			if params[:tag_search_method] == 'or'
				@members = @members.joins(:tags)
								.where(tags: { id: selected_tag_ids })
								.distinct
			else
				@members = @members.joins(:tags)
								.where(tags: { id: selected_tag_ids })
								.group('members.id')
								.having('COUNT(members.id) = ?', selected_tag_ids.length)
			end
		end

		region_ids = params[:region_ids]&.compact_blank
		if region_ids.present?
			if params[:region_search_method] == 'or'
				@members = @members.joins(:regions).where(regions: { id: region_ids }).distinct
			else
				region_ids.each do |region_id|
					@members = @members.where(id: MemberRegion.where(region_id: region_id).select(:member_id))
				end
			end
		end
		
		@members = @members.order(:id)
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
		@tags = Tag.all
		@regions = Region.all
	end

	def update
		@member = Member.find(params[:id])
		if @member.update(member_params)
			redirect_to [:admin, @member], notice: "会員情報を更新しました"
		else
			@tags = Tag.all
			@regions = Region.all
			render :edit
		end
	end

	def ban
		@member = Member.find(params[:id])
		@member.update!(is_banned: true)

		affected = Reservation.where("member_id = :id OR target_member_id = :id", id: @member.id)
							.where.not(status: Reservation.statuses[:completed])

		affected.find_each do |res|
			res.admin_override = true
			res.update(status: :admin_canceled)
		end

		redirect_to [:admin, @member], notice: "会員『#{@member.name}』をBANし、関連する未完了予約をキャンセルしました。"
	end

	# BAN解除: is_banned を false に戻す（予約の復帰は行わない）
	def unban
		@member = Member.find(params[:id])
		@member.update!(is_banned: false)
		redirect_to [:admin, @member], notice: "会員『#{@member.name}』のBANを解除しました。"
	end

	private

	def member_params
		params.require(:member).permit(
		:name, :email, :birthday, :sex, :comment, 
		:special_member, :price_per_hour, :profile_image,
		tag_ids: [], region_ids: []
		)
	end
end