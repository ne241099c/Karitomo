class MembersController < ApplicationController 
    def index
        @tags = Tag.all
        @regions = Region.all
        @members = Member.where(special_member: true)        
    end

    def search
        @tags = Tag.all
        @regions = Region.all
    
        @members = Member.where(special_member: true)

        if params[:search_name].present?
            @members = @members.search_name(params[:search_name])
        end

        selected_tag_ids = params[:tag_ids]&.compact_blank

        if selected_tag_ids.present?
            if params[:tag_search_method] == 'or'
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

        region_ids = params[:region_ids]&.compact_blank
        if region_ids.present?
            if params[:region_search_method] == 'or'
                @members = @members.joins(:regions).where(regions: { id: region_ids }).distinct
            else
                region_ids.each do |region_id|
                    @members = @members.where(id: MemberRegion.where(region_id: region_id).select(:member_id))
                end
            end
        end

        render :index
    end
    
    def show
        @member = Member.find(params[:id])
        @dates = (Date.today..Date.today + 13.days).to_a
        @reservation = Reservation.new
    end
end
