class Admin::BaseController < ApplicationController
	layout "admin"
	
	before_action :admin_login_required

	private

	def current_admin
		@current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
	end
	helper_method :current_admin

	def admin_login_required
		# memberでログイン中の場合は拒否
		if current_member
			redirect_to root_path, alert: "管理者権限が必要です"
			return
		end
		
		unless current_admin
			redirect_to new_admin_session_path, alert: "管理者ログインが必要です"
		end
	end
end