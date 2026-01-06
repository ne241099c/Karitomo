class MembersController < ApplicationController 
    def index
        @tags = Tag.all

        selected_tag_ids = params[:tag_ids]&.compact_blank

        @members = Member.where(special_member: true)

        if selected_tag_ids.present?
            @members = @members.joins(:tags)
                         .where(tags: { id: selected_tag_ids })
                         .group('members.id')
                         .having('COUNT(members.id) = ?', selected_tag_ids.length)
        end
    end
    
    def show
        @member = Member.where(special_member: true).find(params[:id])
    end
end
