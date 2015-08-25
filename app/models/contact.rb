class Contact
  include Virtus.model
  include ActiveModel::Conversion
  include ActiveRecord::Validations

  # Attributes
  attribute :name, String
  attribute :email, String
  attribute :subject, String
  attribute :body, String

  attr_reader :errors

  # Validations
  validates_length_of :name, maximum: 128
  validates_presence_of :name

  validates :email, email: { strict_mode: true }, allow_blank: true
  validates_presence_of :email

  validates_length_of :subject, minimum: 4, maximum: 128
  validates_presence_of :subject

  validates_length_of :body, minimum: 8, maximum: 2048
  validates_presence_of :body

  def self._reflect_on_association(_attribute)
    nil
  end

  def initialize(_args = nil)
    @errors = ActiveModel::Errors.new(self)

    super
  end

  def save
  end

  def save!
  end

  def new_record?
    false
  end

  def update_attribute(_name, _value)
  end

  def persisted?
    false
  end

  def sanitize!
    self.email = email.downcase.strip

    self.subject = Sanitize.clean(subject).gsub(/\n|\r|\t/, '').strip

    self.body = Sanitize.clean(body).gsub(/\r|\t/, '').strip

    self
  end
end
