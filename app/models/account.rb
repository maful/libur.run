# frozen_string_literal: true

class Account < ApplicationRecord
  include Rodauth::Rails.model
  include Account::Invitable

  attr_writer :generate_password, :current_password, :new_password

  has_one :employee, dependent: :destroy

  enum :status, unverified: 1, verified: 2, closed: 3

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates :password, presence: true, if: -> { password_hash.blank? }, on: :account_installation
  validates :password, presence: true, confirmation: true, on: :account_accept_invitation
  validates :password_confirmation, presence: true, if: -> { password.present? }, on: :account_accept_invitation

  validates :current_password, presence: true, on: :account_change_password
  validates :new_password, presence: true, confirmation: true, on: :account_change_password
  validates :new_password_confirmation, presence: true, if: -> { new_password.present? }, on: :account_change_password
  validate :handle_change_password, on: :account_change_password

  before_create :generate_password, if: -> { generate_password.is_a?(TrueClass) }

  private

  attr_reader :generate_password, :current_password, :new_password

  def generate_random_password
    self.password = SecureRandom.base36(10)
  end

  def handle_change_password
    rodauth = Rodauth::Rails.rodauth(account: self)
    unless rodauth.password_match?(current_password)
      errors.add(:current_password, "doesn't match")
    end

    unless rodauth.password_meets_requirements?(new_password)
      errors.add(:new_password, "is too short")
    end

    if rodauth.password_match?(new_password)
      errors.add(:new_password, "is invalid, same as current password")
    end

    self.password = new_password
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                     :bigint           not null, primary key
#  email                  :citext           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  password_hash          :string
#  status                 :integer          default("unverified"), not null
#
# Indexes
#
#  index_accounts_on_email             (email) UNIQUE WHERE (status = ANY (ARRAY[1, 2]))
#  index_accounts_on_invitation_token  (invitation_token) UNIQUE
#
