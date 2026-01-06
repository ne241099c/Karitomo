class MembersController < ApplicationController
    def index
        @members = Member.where(special_member: true)
    end
    
    def show
        @member = Member.where(special_member: true).find(params[:id])
    end
end
