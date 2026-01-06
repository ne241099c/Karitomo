module ApplicationHelper
    def page_title
        title = "Karitomo"
        title = @page_title + " - " + title if @page_title
        title
    end
end
