class Admin::UsersController < Admin::AdminController
  authorize_resource

  helper_method :sort_column, :sort_order

  def index
    @users = User.search(params[:search]).page(params[:page]).order(sort_column + " " + sort_order)
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user.nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find"

      redirect_to admin_users_url and return
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    unless @user.nil?
      if @user.privilege_level > @current_user.privilege_level
        flash[:type] = "attention"

        flash[:notice] = t "flash.user.error.privilege_level_create"

        render :action => :new and return
      end

      if @user.save
        flash[:type] = "success"

        flash[:notice] = t "flash.user.success.created", :user_name => @user.full_name, :undo_link => undo_link

        redirect_to admin_users_url and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@user)

        render :action => :new and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_create"

      redirect_to new_admin_user_url and return
    end
  end

  def edit
    @user = User.find_by_id(params[:id])

    unless @user.nil?
      if @user.privilege_level >= @current_user.privilege_level and @user != @current_user
        flash[:type] = "attention"

        flash[:notice] = t "flash.user.error.privilege_level_edit"

        redirect_to admin_users_url and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find"

      redirect_to admin_users_url and return
    end
  end

  def update
    @user = User.find_by_id(params[:id])

    unless @user.nil?
      if  @user.privilege_level >= @current_user.privilege_level and @user != @current_user
        flash[:type] = "attention"

        flash[:notice] = t "flash.user.error.privilege_level_edit"

        redirect_to admin_users_url and return
      end

      if params[:user][:privilege_level].to_i > @current_user.privilege_level
        flash[:type] = "attention"

        flash[:notice] = t "flash.user.error.privilege_level_update"

        render :action => :edit and return
      end

      if @user.update_attributes(params[:user])
        flash[:type] = "success"

        flash[:notice] = t "flash.user.success.updated", :user_name => @user.first_name.possessive, :undo_link => undo_link

        redirect_to admin_user_url(@user) and return
      else
        flash[:type] = "error"

        flash[:notice] = validation_errors_for(@user)

        render :action => :edit and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find"

      redirect_to admin_users_url and return
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])

    unless @user.nil?
      if @user == @current_user
        User.destroy(@user)

        session[:id] = @current_user = nil

        flash[:type] = "success"

        flash[:notice] = t "flash.user.success.destroyed", :user_name => "Your", :undo_link => ""

        redirect_to root_url and return
      else
        if @user.privilege_level < @current_user.privilege_level
          User.destroy(@user)

          flash[:type] = "success"

          flash[:notice] = t "flash.user.success.destroyed", :user_name => @user.name.possessive, :undo_link => undo_link

          redirect_to admin_users_url and return
        else
          flash[:type] = "attention"

          flash[:notice] = t "flash.user.error.privilege_level_destroy"

          redirect_to admin_users_url and return
        end
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find"

      redirect_to admin_users_url and return
    end
  end

  def edit_multiple
    if params[:users_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end

    @users = User.find(params[:users_ids])

    unless @users.nil?
      unauthorized = false

      @users.each do |user|
        if user.privilege_level >= @current_user.privilege_level and user != @current_user
          unauthorized = true

          flash[:notice] ||= t("flash.user.error.privilege_level_edit_multiple") + "<ul>"

          flash[:notice] += "<li>#{user.name}</li>"
        end
      end

      if unauthorized
        flash[:type] = "attention"

        flash[:notice] += "</ul>"

        redirect_to admin_users_url and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end
  end

  def update_multiple
    if params[:users_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end

    @users = User.find(params[:users_ids])

    unless @users.nil?
      unauthorized = false

      @users.each do |user|
        if user.privilege_level >= @current_user.privilege_level and user != @current_user
          unauthorized = true

          flash[:notice] ||= t("flash.user.error.privilege_level_edit_multiple") + "<ul>"

          flash[:notice] += "<li>#{user.name}</li>"
        end
      end

      if unauthorized
        flash[:type] = "attention"

        flash[:notice] += "</ul>"

        redirect_to admin_users_url and return
      end

      if params[:user][:privilege_level].to_i > @current_user.privilege_level
        flash[:type] = "attention"

        flash[:notice] = t "flash.user.error.privilege_level_update"

        render :action => :edit_multiple and return
      end

      flash[:type] = "success"

      flash[:notice] = ""

      @users.each do |user|
        if user.update_attributes(params[:user].reject { |k, v| v.blank? })
          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.user.success.updated", :user_name => user.name.possessive, :undo_link => ""
        else
          flash[:type] = "error"

          unless flash[:notice].blank?
            flash[:notice] += "<br />"
          end

          flash[:notice] += t "flash.user.error.could_not_update_multiple", :user_name => user.name.possessive

          flash[:notice] += validation_errors_for(user)
        end
      end

      if flash[:type] == "success"
        redirect_to admin_users_url and return
      else
        render :action => :edit_multiple and return
      end
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end
  end

  def destroy_multiple
    if params[:users_ids].nil?
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end

    @users = User.find(params[:users_ids])

    unless @users.nil?
      unless @users.index(@current_user).nil?
        flash[:type] = "error"

        flash[:notice] = t "flash.user.error.cannot_destroy_self_via_multiple"

        redirect_to admin_users_url and return
      end

      unauthorized = false

      @users.each do |user|
        if user.privilege_level >= @current_user.privilege_level
          unauthorized = true

          flash[:notice] ||= t("flash.user.error.privilege_level_destroy_multiple") + "<ul>"

          flash[:notice] += "<li>#{user.name}</li>"
        end
      end

      if unauthorized
        flash[:type] = "attention"

        flash[:notice] += "</ul>"

        redirect_to admin_users_url and return
      end

      flash[:type] = "success"

      flash[:notice] = ""

      @users.each do |user|
        User.destroy(user)

        unless flash[:notice].blank?
          flash[:notice] += "<br />"
        end

        flash[:notice] += t "flash.user.success.destroyed", :user_name => user.name.possessive, :undo_link => ""
      end

      redirect_to admin_users_url and return
    else
      flash[:type] = "error"

      flash[:notice] = t "flash.user.error.could_not_find_multiple"

      redirect_to admin_users_url and return
    end
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_order
    ["asc", "desc"].include?(params[:order]) ? params[:order] : "asc"
  end

  def undo_link
    view_context.link_to(t("flash.versions.undo"), revert_version_path(@user.versions.scoped.last), :method => :post)
  end
end
