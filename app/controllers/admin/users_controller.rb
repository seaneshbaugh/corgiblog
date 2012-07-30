class Admin::UsersController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = User.unscoped.search(params[:q])
    else
      @search = User.search(params[:q])
    end

    @users = @search.result.page(params[:page])
  end

  def show
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      redirect_to admin_users_url, :notice => t('messages.users.could_not_find')
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      redirect_to admin_users_url, :notice => t('messages.users.could_not_find')
    end
  end

  def update
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      redirect_to admin_users_url, :notice => t('messages.users.could_not_find') and return
    end

    if @user.update_attributes(params[:user])
      redirect_to admin_edit_user_url(@user), :notice => t('messages.users.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      redirect_to admin_users_url, :notice => t('messages.users.could_not_find') and return
    end

    @user.destroy

    redirect_to admin_users_url, :notice => t('messages.users.deleted')
  end
end
