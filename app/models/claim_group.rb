# frozen_string_literal: true

class ClaimGroup < ApplicationRecord
  include ClaimGroup::Filterable
  include ClaimGroup::ApprovalStatusMachine
  include PublicIdGenerator
  include ClearCacheCollection

  attribute :submission_date, default: -> { Time.current }

  self.public_id_prefix = "cgr_"

  has_many :claims, dependent: :destroy_async
  belongs_to :employee
  belongs_to :approver, class_name: "Employee", optional: true

  monetize :total_amount_cents, numericality: { greater_than_or_equal_to: 0 }

  accepts_nested_attributes_for :claims,
    reject_if: proc { |attrs|
                 attrs["claim_type_id"].blank? || attrs["issue_date"].blank?
               },
    limit: 10

  validates :name, presence: true
  validates :name, length: { maximum: 50, too_long: "%{count} characters is the maximum allowed" }
  validates :comment, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :submission_date, presence: true

  before_create :set_total_amount, if: proc { claims.present? }

  ransacker :total_amount, formatter: proc { |v| Money.from_amount(v.to_f).cents } do |parent|
    parent.table[:total_amount_cents]
  end

  # overridden
  def to_param
    public_id
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      super & ["public_id", "name", "total_amount"]
    end

    def ransackable_associations(auth_object = nil)
      []
    end

    def ransackable_scopes(auth_object = nil)
      [:by_status]
    end
  end

  private

  # TODO: Each employee may have different currency
  def set_total_amount
    self.total_amount = claims.inject(Money.new(0, "USD")) { |sum, n| sum + n.amount }
  end
end

# == Schema Information
#
# Table name: claim_groups
#
#  id                    :bigint           not null, primary key
#  approval_date         :datetime
#  approval_status       :integer          not null
#  comment               :string(100)
#  name                  :string(50)       not null
#  submission_date       :datetime         not null
#  total_amount_cents    :integer          default(0), not null
#  total_amount_currency :string           default("USD"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  approver_id           :bigint
#  employee_id           :bigint
#  public_id             :string(19)       not null
#
# Indexes
#
#  index_claim_groups_on_approver_id  (approver_id)
#  index_claim_groups_on_employee_id  (employee_id)
#  index_claim_groups_on_public_id    (public_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (approver_id => employees.id)
#
