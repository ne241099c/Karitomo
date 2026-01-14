class SessionsController < ApplicationController
	def new
	end

	def create
		member = Member.find_by(email: params[:session][:email])
		if member&.authenticate(params[:session][:password])
			cookies_login(member.id)
			redirect_to :account, notice: "ログインしました"
		else
			flash.alert = "名前とパスワードが一致しません"
			redirect_to :login
		end
	end

	def destroy
		cookies.delete(:member_id)
		redirect_to :root
	end
end
