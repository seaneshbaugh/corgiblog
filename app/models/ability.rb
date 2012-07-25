class Ability
  include CanCan::Ability

  ROLES = {
    :sysadmin  => 'sysadmin',
    :admin     => 'admin',
    :moderator => 'moderator',
    :read_only => 'read_only'
  }

  def initialize(user)
    @user = user

    # cancan default_alias_actions that already exist
    #    :read => [:index, :show]
    #    :create => [:new]
    #    :update => [:edit]

    alias_action :index, :show, :edit, :update, :to => :touch
    alias_action :edit, :update, :to => :modify

    if @user.sysadmin?
      setup_sysadmin_permissions!
    else
      setup_default_permissions!

      if @user.admin?
        setup_admin_permissions!
      elsif @user.moderator?
        setup_moderator_permissions!
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
    can :read, :admin_panel
    can :reboot, :application
    can :export, :database
  end

  def setup_admin_permissions!
    can [:create, :touch, :destroy], Page
    can [:create, :touch, :destroy], Picture
    can [:create, :touch, :destroy], Post
    can [:create, :touch, :destroy], User
    can :read, :admin_panel
  end

  def setup_moderator_permissions!
    can :touch, Post
    can :read, :admin_panel
  end

  def setup_read_only_permissions!
    cannot :read, :admin_panel
  end
end