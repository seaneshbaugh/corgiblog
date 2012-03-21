require "FasterCSV"
require "FileUtils"

class Admin::AdminController < ApplicationController
  layout "admin"

  helper :all

  skip_before_filter :get_current_user

  before_filter :get_current_user, :is_admin?

  before_filter :is_sysop?, :only => [:reboot, :export]

  def index
    @post = Post.new
  end

  def reboot
    %x[touch "#{File.join(Rails.root, "tmp", "restart.txt")}"]

    flash[:type] = "information"

    flash[:notice] = t "flash.reboot"

    redirect_to admin_root_url and return
  end

  def export
    path = File.join(Rails.root, "tmp", "database-export.csv")

    database = ActiveRecord::Base.connection

    database.tables.each do |table|
      FasterCSV.open(path, "w") do |csv|
        csv << database.columns(table).map(&:name)
      end

    end

    redirect_to admin_root_url and return
  end
end
