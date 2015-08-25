class User < ActiveRecord::Base
  include OptionsForSelect

  # Scopes
  Ability::ROLES.each do |role_name, _|
    scope role_name.to_s.pluralize.to_sym, -> { where(role: Ability::ROLES[role_name].downcase) }
  end

  scope :alphabetical, -> { order(:last_name, :first_name) }

  scope :reverse_alphabetical, -> { order('users.last_name DESC, users.first_name DESC') }

  # Associations
  has_many :posts, dependent: :destroy

  # Validations
  validates :email, email: { strict_mode: true }, allow_blank: true
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false

  validates_confirmation_of :password
  validates_length_of :password, within: 6..255, if: :password_required?
  validates_presence_of :password, if: :password_required?

  validates_inclusion_of :role, in: Ability::ROLES.map { |_, role_value| role_value }
  validates_presence_of :role

  validates_length_of :first_name, maximum: 255
  validates_presence_of :first_name

  validates_length_of :last_name, maximum: 255
  validates_presence_of :last_name

  # Callbacks
  before_save :define_role

  # Default Values
  default_value_for :email, ''

  default_value_for :encrypted_password, ''

  default_value_for :role, Ability::ROLES[:read_only]

  default_value_for :first_name, ''

  default_value_for :last_name, ''

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_paper_trail only: [:email, :role, :first_name, :last_name]

  Ability::ROLES.each do |role_name, _|
    define_method("#{role_name}?") do
      role == role_name.to_s
    end

    define_method("#{role_name}!") do
      self.role = role_name.to_s
    end
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    "#{first_name.first.upcase}. #{last_name}"
  end

  protected

  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end

  def define_role
    self.role = Ability::ROLES.include?(role.downcase.to_sym) ? role.downcase : Ability::ROLES[:read_only]
  end
end
