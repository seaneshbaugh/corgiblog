require "possessive"

class ApplicationController < ActionController::Base
  protect_from_forgery

  layout "application"

  before_filter :get_current_user

  def ensure_login
    if @current_user.nil?
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.must_be_logged_in"

      redirect_to root_url and return
    end
  end

  def ensure_logout
    unless @current_user.nil?
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.already_logged_in"

      redirect_to root_url and return
    end
  end

  def is_moderator?
    if @current_user.nil?
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.must_be_logged_in"

      redirect_to root_url and return
    end

    if @current_user.privilege_level < User::PrivilegeLevelModerator
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.not_authorized"

      redirect_to :back and return
    end
  end

  def is_admin?
    if @current_user.nil?
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.must_be_logged_in"

      redirect_to root_url and return
    end

    if @current_user.privilege_level < User::PrivilegeLevelAdmin
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.not_authorized"

      redirect_to :back and return
    end
  end

  def is_sysop?
    if @current_user.nil?
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.must_be_logged_in"

      redirect_to root_url and return
    end

    if @current_user.privilege_level < User::PrivilegeLevelSysOp
      flash[:type] = "attention"

      flash[:notice] = t "flash.access.not_authorized"

      redirect_to :back and return
    end
  end

  def validation_errors_for(object)
    "<ul>" + object.errors.map {|attribute, message| "<li>#{t("flash.error") + object.class.human_attribute_name("#{attribute.to_s}")} #{message}.</li>"}.join("") + "</ul>"
  end

  private

  def get_current_user
    @current_user ||= User.find_by_remember_me_token(cookies[:remember_me_token]) if cookies[:remember_me_token]
  end
end
