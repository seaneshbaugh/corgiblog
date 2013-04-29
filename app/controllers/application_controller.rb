class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter Proc.new { @pages = Page.where(:show_in_menu => true, :visible => true).order('pages.order ASC') }

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message

    redirect_to root_url
  end
end
