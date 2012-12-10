class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter Proc.new { @pages = Page.where(:show_in_menu => true, :visible => true).order('pages.order ASC') }

  def after_sign_out_path_for(resource_or_scope)
    login_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message

    redirect_to root_url
  end
end
