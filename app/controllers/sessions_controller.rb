class SessionsController < ApplicationController
  def create
        member = Member.find_by(email: params[:session][:email])
        if member&.authenticate(params[:session][:password])
          cookies_login(member.id)
        else
          flash.alert = "名前とパスワードが一致しません"
        end
        redirect_to :account, notice: "ログインしました"
    end

    def destroy
        cookies.delete(:member_id)
        redirect_to :root
    end
end
