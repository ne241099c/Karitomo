class AccountsController < ApplicationController
  before_action :login_required, except: [:new, :create]

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
    @member = Member.new(params[:member].permit!)
    if @member.save
      cookies_login(@member.id)
      redirect_to root_path, notice: "会員を登録しました。"
    else
      render :account
    end
  end

  def update
    @member = current_member
    @member.assign_attributes(params[:member].permit!)
    if @member.save
      redirect_to account_path, notice: "アカウント情報を更新しました"
    else
      render :edit
    end
  end
end
