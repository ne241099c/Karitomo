class MembersController < ApplicationController 
    def index
        @tags = Tag.all
        @members = Member.where(special_member: true)        
    end

    def search
        @tags = Tag.all
    
        @members = Member.where(special_member: true)

        if params[:search_name].present?
            @members = @members.search_name(params[:search_name])
        end

        selected_tag_ids = params[:tag_ids]&.compact_blank

        if selected_tag_ids.present?
            if params[:search_method] == 'or'
                @members = @members.joins(:tags)
                                   .where(tags: { id: selected_tag_ids })
                                   .distinct
            else
                @members = @members.joins(:tags)
                                   .where(tags: { id: selected_tag_ids })
                                   .group('members.id')
                                   .having('COUNT(members.id) = ?', selected_tag_ids.length)
            end
        end

        render :index
    end
    
    def show
        @member = Member.where(special_member: true).find(params[:id])
    end
end
