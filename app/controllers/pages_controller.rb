class PagesController < ApplicationController
  def show
    @page = Page.published.where(slug: params[:id]).first

    if @page.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
