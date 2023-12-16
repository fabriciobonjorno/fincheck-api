# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # Callbacks
  before_save :capitalize_name

  # Validates
  validates :name, :birth_date, :password_digest, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validate :password_regex
  validate :email_regex

  # Normalizes
  normalizes :email, with: -> { _1.strip.downcase }

  # Relationship
  has_many :bank_accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  # Public methods
  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_token_sent_at = Time.now
    save
  end

  # Private methods
  private

  def capitalize_name
    self.name = Util.capitalize_name(name)
  end

  def password_regex
    return if password.blank? || Util.password_regex(password)

    errors.add :base, I18n.t('users.errors.password')
  end

  def email_regex
    return if email.blank? || Util.email_regex(email)

    errors.add :base, I18n.t('users.errors.email')
  end
end
