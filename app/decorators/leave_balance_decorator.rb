# frozen_string_literal: true

class LeaveBalanceDecorator < ApplicationDecorator
  delegate_all

  def leave_type_with_balance
    "#{object.leave_type.name} - #{h.pluralize(display_remaining_balance, "day")}"
  end

  def display_remaining_balance
    format_balance_number(object.remaining_balance)
  end

  def display_entitled_balance
    format_balance_number(object.entitled_balance)
  end

  private

  def format_balance_number(value)
    return value.to_i if value.frac.zero?

    value.to_f
  end
end
