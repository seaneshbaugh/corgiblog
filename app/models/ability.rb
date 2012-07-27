class Ability
  include CanCan::Ability

  ROLES = {
    :read_only => 'read_only',
    :contributor => 'contributor',
    :admin => 'admin',
    :sysadmin => 'sysadmin'
  }

  def initialize(user)
    @user = user

    alias_action :index, :show, :to => :read
    alias_action :index, :show, :edit, :update, :destroy, :to => :touch
    alias_action :edit, :update, :to => :modify

    if @user.sysadmin?
      setup_sysadmin_permissions!
    else
      setup_default_permissions!

      if @user.admin?
        setup_admin_permissions!
      elsif @user.contributor?
        setup_contributor_permissions!
      else
        setup_read_only_permissions!
      end
    end
  end

  def setup_default_permissions!
    cannot :manage, :all
  end

  def setup_sysadmin_permissions!
    can :manage, :all
  end

  def setup_admin_permissions!
    can [:create, :touch], Campaign
    can [:create, :touch], CreativeElement
    can [:create, :touch], User
  end

  def setup_contributor_permissions!
    can [:create, :touch], Campaign
    can [:create, :touch], CreativeElement
  end

  def setup_read_only_permissions!

  end
end