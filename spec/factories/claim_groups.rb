# frozen_string_literal: true

FactoryBot.define do
  factory :claim_group do
    association :employee
    sequence(:name) { |n| "Group #{n}" }
    approval_date { nil }
    approval_status { :pending }
    comment { nil }
    total_amount { Money.from_amount(120, "USD") }

    trait :approved do
      approval_status { :approved }
    end

    trait :denied do
      approval_status { :denied }
    end

    trait :canceled do
      approval_status { :canceled }
    end

    trait :completed do
      approval_status { :completed }
    end
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
