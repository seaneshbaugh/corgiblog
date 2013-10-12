require 'active_record/validations'
require 'active_model/errors'

class Contact
  include ActiveModel::Conversion
  include ActiveRecord::Validations

  attr_accessor :name
  attr_accessor :email
  attr_accessor :subject
  attr_accessor :body

  attr_reader :errors

  validates_presence_of :name

  validates_presence_of :email
  validates_format_of   :email, :with => RFC822::EmailAddress

  validates_presence_of :subject
  validates_length_of   :subject, :minimum => 4, :maximum => 128

  validates_presence_of :body
  validates_length_of   :body, :minimum => 8, :maximum => 2048

  def initialize(args = nil)
    @errors = ActiveModel::Errors.new(self)

    if args
      args.each do |key, value|
        instance_variable_set("@#{key}", value) unless value.nil?
      end
    end
  end

  def save
  end

  def save!
  end

  def new_record?
    false
  end

  def update_attribute
  end

  def persisted?
    false
  end
end
