class PagesController < ApplicationController
  def show
    @page = Page.published.where(slug: params[:id]).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to root_url
    end
  end
end
