class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter -> { @pages = Page.published.in_menu.by_order }

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message

    redirect_to root_url
  end
end
