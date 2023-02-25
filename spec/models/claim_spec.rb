# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Claim) do
  describe "associations" do
    it { should belong_to(:claim_group).optional }
    it { should belong_to(:claim_type) }
    it { should belong_to(:employee).optional }
    it { should have_one_attached(:receipt) }
  end

  describe "validations" do
    subject { build(:claim) }

    it { should validate_presence_of(:issue_date) }
    it { should validate_length_of(:note).is_at_most(200).with_message("200 characters is the maximum allowed") }
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
