class Admin::SessionsController < Admin::BaseController
	skip_before_action :admin_login_required, only: [:new, :create]

	def new
	end

	def create
		admin = Admin.find_by(name: params[:name])
		if admin&.authenticate(params[:password])
			session[:admin_id] = admin.id
			redirect_to :admin_root, notice: "ログインしました"
		else
			flash.now[:alert] = "名前またはパスワードが正しくありません"
			render :new
		end
	end

	def destroy
		session.delete(:admin_id)
		redirect_to :new_admin_session, notice: "ログアウトしました"
	end
end