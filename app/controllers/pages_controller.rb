class PagesController < ApplicationController
  def show
    @page = Page.where(:slug => params[:id], :visible => true).first

    if @page.nil?
      flash[:error] = t('messages.pages.could_not_find')

      redirect_to root_url
    end
  end
end
