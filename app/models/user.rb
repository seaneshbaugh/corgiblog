class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :role, :first_name, :last_name, :remember_me

  has_paper_trail :only => [:email, :role, :first_name, :last_name]

  has_many :posts, :dependent => :destroy

  validates_format_of     :email, :with => Devise.email_regexp, :allow_blank => true
  validates_presence_of   :email
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true

  validates_confirmation_of :password
  validates_length_of       :password, :within => 6..255, :if => :password_required?
  validates_presence_of     :password, :if => :password_required?

  validates_inclusion_of :role, :in => Ability::ROLES.map { |key, value| value }
  validates_presence_of  :role

  validates_length_of   :first_name, :maximum => 255
  validates_presence_of :first_name

  validates_length_of   :last_name, :maximum => 255
  validates_presence_of :last_name

  after_initialize do
    if self.new_record?
      self.email ||= ''
      self.encrypted_password ||= ''
      self.role ||= ''
      self.first_name ||= ''
      self.last_name ||= ''
      self.sign_in_count ||= 0
    end
  end

  before_save :define_role

  Ability::ROLES.each do |k, v|
    class_eval %Q"scope :#{k.to_s.pluralize}, where(:role => Ability::ROLES[:#{k.to_s}].downcase)"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def short_name
    "#{self.first_name.first.upcase}. #{self.last_name}"
  end

  Ability::ROLES.each do |k, v|
    define_method("#{k.to_s}?") do
      self.role == k.to_s
    end

    define_method("#{k.to_s}!") do
      self.role = k.to_s
    end
  end

  def ability
    @ability ||= Ability.new(self)
  end

  protected

  def password_required?
    !self.persisted? || !self.password.blank? || !self.password_confirmation.blank?
  end

  def define_role
    self.role = Ability::ROLES.include?(role.downcase.to_sym) ? role.downcase : Ability::ROLES[:read_only]
  end
end
