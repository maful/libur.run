# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimType) do
  describe "validations" do
    subject { build(:claim_type) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50).with_message("50 characters is the maximum allowed") }
    it { should validate_length_of(:description).is_at_most(100).with_message("100 characters is the maximum allowed") }
  end
end

# == Schema Information
#
# Table name: claim_types
#
#  id          :bigint           not null, primary key
#  description :string(100)
#  name        :string(50)       not null
#  status      :boolean          default(TRUE)
#  year        :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string(19)       not null
#
# Indexes
#
#  index_claim_types_on_public_id      (public_id) UNIQUE
#  index_claim_types_on_year_and_name  (year,name) UNIQUE
#
