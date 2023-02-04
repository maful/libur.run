# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Onboarding) do
  describe "associations" do
    it { should belong_to(:employee).optional }
  end

  describe "validations" do
    subject { build(:onboarding) }

    it { should define_enum_for(:state).with_values([:pending, :in_progress, :completed]) }
  end

  describe "database" do
    it { should have_db_column(:state).of_type(:integer).with_options(null: false, limit: 2) }
    it { should have_db_column(:employee_id).of_type(:integer) }
    it { should have_db_column(:subscribe).of_type(:boolean).with_options(default: false) }
  end
end

# == Schema Information
#
# Table name: onboardings
#
#  id          :bigint           not null, primary key
#  state       :integer          default("pending"), not null
#  subscribe   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :bigint
#
# Indexes
#
#  index_onboardings_on_employee_id  (employee_id)
#
