class Admin::UsersController < Admin::AdminController
  authorize_resource

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @search = User.search(params[:q])

    @users = @search.result.page(params[:page]).per(25).alphabetical
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'User was successfully created.'

      redirect_to admin_user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'

      redirect_to edit_admin_user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @user.destroy

    flash[:success] = 'User was successfully deleted.'

    redirect_to admin_users_url
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first

    fail ActiveRecord::RecordNotFound if @user.nil?
  end

  def user_params
    params.required(:user).permit(:email, :password, :password_confirmation, :role, :first_name, :last_name)
  end
end
