# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveBalanceDecorator) do
  let(:decorator) { LeaveBalanceDecorator.new(object) }
  let(:object) { create(:leave_balance) }

  it "can get leave type with balance" do
    value = "#{object.leave_type.name} - 14 days"
    expect(decorator.leave_type_with_balance).to(eq(value))
  end

  it "can get the remaining balance" do
    expect(decorator.display_remaining_balance).to(eq(object.remaining_balance.to_i))
  end
end
