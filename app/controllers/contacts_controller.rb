class ContactsController < ApplicationController
	before_action :login_required

	def new
		@contact = current_member.contacts.build
	end

	def create
		@contact = current_member.contacts.build(contact_params)
		if @contact.save
			redirect_to root_path, notice: "お問い合わせを受け付けました。"
		else
			render :new, status: :unprocessable_entity
		end
	end

	private

	def contact_params
		params.require(:contact).permit(:message)
	end
end
