# frozen_string_literal: true

class Claim < ApplicationRecord
  include PublicIdGenerator

  self.public_id_prefix = "cla_"

  belongs_to :claim_group, optional: true
  belongs_to :claim_type
  belongs_to :employee, optional: true

  has_one_attached :receipt

  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :issue_date, presence: true
  validates :note, length: { maximum: 200, too_long: "%{count} characters is the maximum allowed" }
  validates :receipt,
    content_type: ["image/png", "image/jpeg", "application/pdf"],
    size: { less_than_or_equal_to: 1.megabytes }
end

# == Schema Information
#
# Table name: claims
#
#  id              :bigint           not null, primary key
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  issue_date      :date             not null
#  note            :string(200)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  claim_group_id  :bigint
#  claim_type_id   :bigint
#  employee_id     :bigint
#  public_id       :string(19)       not null
#
# Indexes
#
#  index_claims_on_claim_group_id  (claim_group_id)
#  index_claims_on_claim_type_id   (claim_type_id)
#  index_claims_on_employee_id     (employee_id)
#  index_claims_on_public_id       (public_id) UNIQUE
#
