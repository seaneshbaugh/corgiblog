# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_action :load_pages

  private

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end

  def load_pages
    @pages = Page.published.in_menu.by_order
  end
end
