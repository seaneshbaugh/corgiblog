class Admin::AccountsController < Admin::AdminController
  before_filter :authenticate_user!

  def show
    @account = current_user
  end

  def edit
    @account = current_user
  end

  def update
    @account = current_user

    params[:account].delete(:role) if params[:account]

    if @account.update_attributes(params[:account])
      sign_in(@account, :bypass => true)

      flash[:success] = t('messages.accounts.updated')

      redirect_to admin_account_path
    else
      flash[:error] = @account.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end
end
