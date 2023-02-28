# frozen_string_literal: true

class Company < ApplicationRecord
  include PublicIdGenerator

  MAX_LOGO_SIZE = 1.megabyte

  self.public_id_prefix = "com_"

  has_one_attached :logo
  has_one :address, as: :addressable
  belongs_to :finance_approver, class_name: "Employee", optional: true

  accepts_nested_attributes_for :address, update_only: true

  validates :name, presence: true
  validates :email,
    presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  validates :logo,
    blob: {
      content_type: ["image/png", "image/jpeg"],
      size_range: 1..MAX_LOGO_SIZE,
    }
end

# == Schema Information
#
# Table name: companies
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  name                :string           not null
#  phone               :string
#  website             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finance_approver_id :bigint
#  public_id           :string(19)       not null
#
# Indexes
#
#  index_companies_on_email                (email) UNIQUE
#  index_companies_on_finance_approver_id  (finance_approver_id)
#  index_companies_on_public_id            (public_id) UNIQUE
#
