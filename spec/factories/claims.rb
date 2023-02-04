# frozen_string_literal: true

FactoryBot.define do
  factory :claim do
    association :claim_group
    association :claim_type
    association :employee
    issue_date { Date.current }
    note { Faker::Lorem.paragraph(sentence_count: 2) }
    amount { Money.from_amount(12, "USD") }
  end
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
