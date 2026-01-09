class Admin::ContactsController < Admin::BaseController
  def index
    @contacts = Contact.includes(:member).order(created_at: :desc)
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to admin_contacts_path, notice: "お問い合わせを削除しました。"
  end
end