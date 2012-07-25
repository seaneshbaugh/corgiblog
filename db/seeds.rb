require 'highline'
require 'highline/import'
require 'RFC2822'

def prompt_for_admin_field(prompt, echo, validate, validate_response, default)
  field = ask(prompt) do |q|
    q.echo = echo
    unless validate.blank?
      q.validate = validate
      q.responses[:not_valid] = validate_response
    end
    q.whitespace = :strip
  end

  field = default if field.blank?
  field
end

def create_admin_user
  puts 'Create the admin user (press enter for defaults).'
  email = prompt_for_admin_field('E-mail Address: ', true, RFC2822::EmailAddress, 'Invalid e-mail address. Must be a valid e-mail address.', 'admin@conneythecorgi.com')
  password = prompt_for_admin_field('Password: ', false, /^([\x20-\x7E]){6,255}$/, 'Invalid password. Must be between 6 and 255 characters.', 'corgisrule')

  first_name = 'Admin'
  last_name = 'User'
  phone_number = '214-000-0000'

  attributes = {
    :email => email,
    :email_confirmation => email,
    :password => password,
    :password_confirmation => password,
    :first_name => first_name,
    :last_name => last_name,
    :phone_number => phone_number
  }

  load 'user.rb'

  if User.find_by_email(email.downcase)
    puts "\nWARNING: There is already a user with the e-mail address: #{email}, so no account changes were made.\nIf you wish to create an additional admin user, please run rake db:seed again and enter a different e-mail address.\n\n"
  else
    admin = User.create(attributes)

    admin.role = Ability::ROLES[:sysadmin]

    admin.save
  end
end

create_admin_user unless User.sysadmins.any?
