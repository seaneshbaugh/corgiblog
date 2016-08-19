class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_paper_trail_whodunnit

  before_action -> { @pages = Page.published.in_menu.by_order }

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message

    redirect_to root_url
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end
end
