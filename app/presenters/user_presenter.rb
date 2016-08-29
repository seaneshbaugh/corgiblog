class UserPresenter < BasePresenter
  def self.display_method
    :full_name
  end

  def self.version_display_attributes
    [
      {
        method: :full_name,
        header_class: 'col-xs-4'
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

  def current_sign_in_at(format = :default)
    if @user.current_sign_in_at.present?
      l(@user.current_sign_in_at, format: format)
    else
      t('na')
    end
  end

  def email_link
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-envelope'), "mailto:#{@user.email}", rel: 'tooltip', title: t('send_email'))
  end

  def last_sign_in_at(format = :default)
    if @user.last_sign_in_at.present?
      l(@user.last_sign_in_at, format: format)
    else
      t('na')
    end
  end

  def role
    @user.role.titleize
  end
end
