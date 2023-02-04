# frozen_string_literal: true

class LeaveBalance < ApplicationRecord
  include LeaveBalance::Filterable

  belongs_to :employee
  belongs_to :leave_type

  attribute :year, default: -> { Date.current.year }

  validates :entitled_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :remaining_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :year, presence: true
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
