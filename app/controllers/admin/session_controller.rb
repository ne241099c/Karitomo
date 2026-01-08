class Admin::SessionsController < Admin::BaseController
  skip_before_action :admin_login_required, only: [:new, :create]

  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to :admin_root, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to :admin_login, notice: "ログアウトしました"
  end
end