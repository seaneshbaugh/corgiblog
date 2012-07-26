module ControllerSupport
  def login_as_sysadmin
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:sysadmin_user)
    end
  end

  def login_as_admin
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:admin_user)
    end
  end

  def login_as_manager
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:contributor_user)
    end
  end

  def login_as_read_only
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in create(:read_only_user)
    end
  end
end
