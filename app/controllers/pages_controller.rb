class PagesController < ApplicationController
  def show
    @page = Page.published.where(slug: params[:id]).first

    fail ActionController::RoutingError, 'Not Found' if @page.nil?
  end
end
