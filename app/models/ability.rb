class Ability
  include CanCan::Ability

  ROLES = {
    read_only: 'read_only',
    admin: 'admin',
    sysadmin: 'sysadmin'
  }

  def initialize(user)
    user ||= User.new

    cannot :manage, :all

    case user.role
    when ROLES[:sysadmin] then
      can :manage, :all

      cannot [:destroy], User do |u|
        u.id == user.id
      end
    when ROLES[:admin] then
      can :manage, :all

      cannot [:update, :destroy], User do |u|
        u.role == ROLES[:sysadmin]
      end
    when ROLES[:read_only] then
      can :read, :all
    else
      cannot :read, :all
    end
  end

  def self.valid_roles(user)
    roles = {}

    if user.role == ROLES[:admin]
      roles = ROLES.reject { |key, _| key == :sysadmin }
    elsif user.role == ROLES[:sysadmin]
      roles = ROLES
    end

    roles
  end
end
