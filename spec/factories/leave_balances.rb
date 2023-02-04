# frozen_string_literal: true

FactoryBot.define do
  factory :leave_balance do
    association :employee
    association :leave_type
    remaining_balance { leave_type.days_per_year }
    entitled_balance { leave_type.days_per_year }
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
