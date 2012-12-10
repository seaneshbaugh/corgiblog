class Admin::AccountsController < Admin::AdminController
  before_filter :authenticate_user!

  def show
    @account = User.where(:id => current_user.id).first
  end

  def edit
    @account = User.where(:id => current_user.id).first
  end

  def update
    @account = User.where(:id => current_user.id).first

    params[:account].delete(:role) if params[:account]

    if @account.update_attributes(params[:account])
      sign_in(@account, :bypass => true)

      flash[:success] = t('messages.accounts.updated')

      redirect_to account_path
    else
      flash[:error] = @account.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end
end
