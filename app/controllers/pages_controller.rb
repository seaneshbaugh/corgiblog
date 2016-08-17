class PagesController < ApplicationController
  def show
    @page = Page.published.where(slug: params[:id]).first

    raise ActiveRecord::RecordNotFound if @page.nil?
  end
end
