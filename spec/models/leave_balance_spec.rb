# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveBalance) do
  describe "associations" do
    it { should belong_to(:employee) }
    it { should belong_to(:leave_type) }
  end

  describe "validations" do
    subject { build(:leave_balance) }

    it { should validate_presence_of(:entitled_balance) }
    it { should validate_numericality_of(:entitled_balance).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:remaining_balance) }
    it { should validate_numericality_of(:remaining_balance).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:year) }
  end
end

# == Schema Information
#
# Table name: leave_balances
#
#  id                :bigint           not null, primary key
#  entitled_balance  :decimal(4, 2)    not null
#  remaining_balance :decimal(4, 2)    not null
#  year              :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  employee_id       :bigint
#  leave_type_id     :bigint
#
# Indexes
#
#  index_leave_balances_on_employee_id                             (employee_id)
#  index_leave_balances_on_employee_id_and_leave_type_id_and_year  (employee_id,leave_type_id,year) UNIQUE
#  index_leave_balances_on_leave_type_id                           (leave_type_id)
#  index_leave_balances_on_year                                    (year)
#
