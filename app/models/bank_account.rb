# frozen_string_literal: true

class BankAccount < ApplicationRecord
  # Callbacks
  before_save :capitalize_name

  # Validates
  validates :name, :initial_balance, :account_type, :color, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: %i[user_id deleted_at] }, if: -> { will_save_change_to_name? }

  # Scopes
  scope :all_bank_accounts, -> { where(deleted_at: nil) }

  # Normalizes
  normalizes :name, :color, with: -> { _1.strip }

  # Relationship
  belongs_to :user
  has_many :transactions

  # Enum
  enum account_type: %i[checking saving investment cash]

  # Private methods
  private

  def capitalize_name
    self.name = Util.capitalize_name(name) if name_changed?
  end
end
