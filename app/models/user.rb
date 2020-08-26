# frozen_string_literal: true

class User < ApplicationRecord
  include FriendlyId
  include OptionsForSelect

  scope :alphabetical, -> { order(:last_name, :first_name) }
  scope :reverse_alphabetical, -> { order(last_name: :desc, first_name: :desc) }

  has_many :posts, dependent: :destroy

  validates :email, presence: true, email: { allow_blank: true }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  after_commit :assign_default_role, on: :create

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  friendly_id :full_name

  has_paper_trail only: %i[email first_name last_name]

  rolify

  resourcify :other_users

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
