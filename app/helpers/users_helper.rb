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
end
