class Ability
  include CanCan::Ability

  ROLES = {
    read_only: 'read_only',
    admin: 'admin',
    sysadmin: 'sysadmin'
  }.freeze

  def initialize(user)
    user ||= User.new

    cannot :manage, :all

    case user.role
    when ROLES[:sysadmin] then
      can :manage, :all

      cannot [:destroy], User do |other_user|
        other_user.id == user.id
      end
    when ROLES[:admin] then
      can :manage, :all

      cannot [:edit, :update, :destroy], User do |other_user|
        other_user.sysadmin? || other_user.admin?
      end

      cannot [:edit, :update, :destroy], Post do |post|
        post.user.sysadmin? || (post.user.admin? && post.user != user)
      end
    when ROLES[:read_only] then
      can :read, :all
    else
      cannot :read, :all
    end
  end

  def self.valid_roles_for(user)
    case user.role
    when ROLES[:sysadmin]
      ROLES
    when ROLES[:admin]
      ROLES.reject { |key, _| key == :sysadmin }
    else
      {}
    end
  end
end
