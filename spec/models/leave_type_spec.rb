# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveType) do
  describe "validations" do
    subject { build(:leave_type) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:days_per_year) }
    it { should validate_numericality_of(:days_per_year).is_greater_than(0) }
    it { should validate_presence_of(:year) }
  end
end

# == Schema Information
#
# Table name: leave_types
#
#  id            :bigint           not null, primary key
#  days_per_year :integer          not null
#  name          :string           not null
#  status        :boolean          default(TRUE)
#  year          :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  public_id     :string(19)       not null
#
# Indexes
#
#  index_leave_types_on_year  (year)
#
