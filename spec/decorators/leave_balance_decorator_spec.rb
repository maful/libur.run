# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveBalanceDecorator) do
  let(:decorator) { described_class.new(object) }
  let(:object) { create(:leave_balance) }

  it "can get leave type with balance" do
    expected = "#{object.leave_type.name} - 14 days"
    expect(decorator.leave_type_with_balance).to(eq(expected))
  end

  it "can get the remaining balance" do
    expect(decorator.display_remaining_balance).to(eq(object.remaining_balance.to_i))
  end

  it "can get entitled balance" do
    expect(decorator.display_entitled_balance).to(eq(object.entitled_balance.to_i))
  end

  context "can get entitled balance with non-zero fraction" do
    before do
      object.update(entitled_balance: 12.5)
    end

    it { expect(decorator.display_entitled_balance).to(eq(object.entitled_balance.to_f)) }
  end
end
