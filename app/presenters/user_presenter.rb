class UserPresenter < BasePresenter
  def self.display_method
    :full_name
  end

  def self.humanized_attribute_names
    @humanized_attribute_names ||= HashWithIndifferentAccess.new({
      id: 'ID',
      email: 'Email',
      role: 'Role',
      first_name: 'First Name',
      last_name: 'Last Name',
      reset_password_sent_at: 'Reset Password Sent At',
      remember_created_at: 'Remember Created At',
      sign_in_count: 'Sign In Count',
      current_sign_in_at: 'Current Sign In At',
      last_sign_in_at: 'Last Sign In At',
      current_sign_in_ip: 'Current Sign In IP',
      last_sign_in_ip: 'Last Sign In IP',
      created_at: 'Created At',
      updated_at: 'Updated At'
    })
  end

  def self.version_display_attributes
    [
      {
        method: :full_name,
        header_class: 'col-xs-4',
      },
      {
        method: :email,
        header_class: 'col-xs-3'
      }
    ]
  end

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
