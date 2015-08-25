class UserPresenter < BasePresenter
  def initialize(user, template)
    super

    @user = user
  end

  def current_sign_in_at
    if @user.current_sign_in_at.present?
      @user.current_sign_in_at.strftime(time_format)
    else
      'N/A'
    end
  end

  def email_link
    link_to '<span class="glyphicon glyphicon-envelope">'.html_safe, "mailto:#{@user.email}", rel: 'tooltip', title: 'Send Email'
  end

  def last_sign_in_at
    if @user.last_sign_in_at.present?
      @user.last_sign_in_at.strftime(time_format)
    else
      'N/A'
    end
  end

  def role
    @user.role.titleize
  end
end
