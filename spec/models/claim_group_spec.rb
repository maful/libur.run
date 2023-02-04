# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimGroup) do
  describe "associations" do
    it { should have_many(:claims).dependent(:destroy_async) }
    it { should belong_to(:employee) }
    it { should belong_to(:approver).class_name("Employee").optional }
  end

  describe "validations" do
    subject { build(:claim_group) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50).with_message("50 characters is the maximum allowed") }
    it { should validate_presence_of(:submission_date) }
    it { should accept_nested_attributes_for(:claims).limit(10) }
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
