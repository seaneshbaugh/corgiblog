module UsersHelper
  def get_valid_privilege_levels
    privilege_levels = [['Guest', 0], ['User', 1]]

    if @current_user.privilege_level >= 2
      privilege_levels << ['Moderator', 2]

      if @current_user.privilege_level >= 3
        privilege_levels << ['Admin', 3]

        if @current_user.privilege_level >= 4
          privilege_levels << ['Sysop', 4]
        end
      end
    end

    return privilege_levels
  end

  def get_valid_roles
    roles = [[Ability::ROLES[:read_only].humanize.titleize, Ability::ROLES[:read_only]]]

    if current_user.sysadmin?
      roles += [[Ability::ROLES[:moderator].humanize.titleize, Ability::ROLES[:moderator],
                [Ability::ROLES[:admin].humanize.titleize, Ability::ROLES[:admin]],
                [Ability::ROLES[:sysadmin].humanize.titleize, Ability::ROLES[:sysadmin]]]]
    elsif current_user.admin?
      roles += [[Ability::ROLES[:moderator].humanize.titleize, Ability::ROLES[:moderator],
                [Ability::ROLES[:admin].humanize.titleize, Ability::ROLES[:admin]]]]
    end
  end
end
