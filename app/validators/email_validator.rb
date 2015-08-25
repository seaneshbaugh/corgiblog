# Taken from https://github.com/gitlabhq/gitlabhq/blob/master/lib/email_validator.rb
# Based on https://github.com/balexand/email_validator
#
# Extended to use only strict mode with following allowed characters:
# ' - apostrophe
#
# See http://www.remote.org/jochen/mail/info/chars.html
#
class EmailValidator < ActiveModel::EachValidator
  @default_options = {}

  class << self
    attr_accessor :default_options
  end

  def self.default_options
    @default_options
  end

  def validate_each(record, attribute, value)
    return if value =~ /\A\s*([-a-z0-9+._']{1,64})@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*\z/i

    options = @default_options.merge(self.options)

    record.errors.add(attribute, options[:message] || :invalid)
  end
end
