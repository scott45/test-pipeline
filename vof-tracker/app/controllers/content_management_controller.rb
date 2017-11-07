class ContentManagementController < ApplicationController
  def index
    @content = ContentManagementFacade.new.get_content
  end
end
