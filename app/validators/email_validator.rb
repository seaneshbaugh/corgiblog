# Taken from https://github.com/gitlabhq/gitlabhq/blob/master/app/validators/email_validator.rb

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless value =~ Devise.email_regexp
  end
end
