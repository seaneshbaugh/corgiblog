class Admin::AdminController < ApplicationController
  layout "admin"

  helper :all

  skip_before_filter :get_current_user

  before_filter :get_current_user, :is_admin?

  before_filter :is_sysop?, :only => :reboot

  def index
    @post = Post.new
  end

  def reboot
    %x[touch "#{File.join(Rails.root, "tmp", "restart.txt")}"]

    flash[:type] = "information"

    flash[:notice] = t "flash.reboot"

    redirect_to admin_root_url and return
  end
end
