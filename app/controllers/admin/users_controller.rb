class Admin::UsersController < Admin::AdminController
  before_filter :authenticate_user!

  authorize_resource

  def index
    @search = User.search(params[:q])

    @users = @search.result.page(params[:page]).per(25).order('`users`.`last_name` ASC')
  end

  def show
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      flash[:error] = t('messages.users.could_not_find')

      redirect_to admin_users_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = t('messages.users.created')

      if params[:redirect_to_new].present?
        redirect_to new_admin_user_url
      else
        redirect_to admin_users_url
      end
    else
      flash[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      flash[:error] = t('messages.users.could_not_find')

      redirect_to admin_users_url
    end
  end

  def update
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      flash[:error] = t('messages.users.could_not_find')

      redirect_to admin_users_url and return
    end

    if @user.update_attributes(params[:user])
      flash[:success] = t('messages.users.updated')

      redirect_to edit_admin_user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @user = User.where(:id => params[:id]).first

    if @user.nil?
      flash[:error] = t('messages.users.could_not_find')

      redirect_to admin_users_url and return
    end

    @user.destroy

    flash[:success] = t('messages.users.deleted')

    redirect_to admin_users_url
  end
end
