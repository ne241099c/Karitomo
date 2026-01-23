class Admin::StatisticsController < Admin::BaseController
	def index
		# 会員統計
		@total_members = Member.count
		@male_members = Member.where(sex: 1).count
		@female_members = Member.where(sex: 2).count
		@special_members = Member.where(special_member: true).count
		@banned_members = Member.where(is_banned: true).count
		
		# 予約統計
		@total_reservations = Reservation.count
		@pending_reservations = Reservation.pending.count
		@approved_reservations = Reservation.where(status: [:approved_unpaid, :approved_paid]).count
		@completed_reservations = Reservation.completed.count
		@canceled_reservations = Reservation.where(status: [:canceled, :admin_canceled]).count
		@rejected_reservations = Reservation.rejected.count
		
		# 今月の予約
		@this_month_reservations = Reservation.where(
			created_at: Time.current.beginning_of_month..Time.current.end_of_month
		).count
		
		# 今週の予約
		@this_week_reservations = Reservation.where(
			created_at: Time.current.beginning_of_week..Time.current.end_of_week
		).count
		
		# レビュー統計
		@total_reviews = Review.count
		@average_score = Review.average(:score).to_f.round(2)
		
		# タグ・地域統計
		@total_tags = Tag.count
		@total_regions = Region.count
		
		# ブロック統計
		@total_blocks = BlockedMember.count
		
		# お問い合わせ統計
		@total_contacts = Contact.count
		@this_month_contacts = Contact.where(
			created_at: Time.current.beginning_of_month..Time.current.end_of_month
		).count
		
		# 通報統計
		@total_reports = Report.count
		@this_month_reports = Report.where(
			created_at: Time.current.beginning_of_month..Time.current.end_of_month
		).count
		
		# ブックマーク統計
		@total_bookmarks = Bookmark.count
		
		# チャット統計
		@total_chats = Chat.count
		@this_month_chats = Chat.where(
			created_at: Time.current.beginning_of_month..Time.current.end_of_month
		).count
		
		# 売上統計（完了した予約の合計）
		completed_reservations = Reservation.completed.includes(:target_member)
		@total_revenue = completed_reservations.sum do |reservation|
			reservation.hours * reservation.target_member.price_per_hour
		end
		
		# 今月の売上
		this_month_completed = Reservation.completed.includes(:target_member).where(
			updated_at: Time.current.beginning_of_month..Time.current.end_of_month
		)
		@this_month_revenue = this_month_completed.sum do |reservation|
			reservation.hours * reservation.target_member.price_per_hour
		end
		
		# 最も予約されているスペシャル会員TOP5
		@top_special_members = Member.where(special_member: true)
			.left_joins(:passive_reservations)
			.group('members.id')
			.select('members.*, COUNT(reservations.id) as reservations_count')
			.order('reservations_count DESC')
			.limit(5)
		
		# 最も利用されているタグTOP5
		@top_tags = Tag.left_joins(:members)
			.group('tags.id')
			.select('tags.*, COUNT(member_tags.id) as usage_count')
			.order('usage_count DESC')
			.limit(5)
	end
end
