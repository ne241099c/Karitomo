class PasswordsController < ApplicationController
  before_action :login_required

  def show
    redirect_to account_path
  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    current_password = params[:member][:current_password]

    if current_password.present?
      if @member.authenticate(current_password)
        @member.assign_attributes(params[:member].permit!)
        if @member.save
          redirect_to account_path, notice: "パスワードを変更しました。"
        else
          render :edit
        end
      else
        @member.errors.add(:current_password, :wrong, message: "が間違っています")
        render :edit
      end
    else
      @member.errors.add(:current_password, :empty, message: "を入力してください")
      render :edit
    end
  end
end