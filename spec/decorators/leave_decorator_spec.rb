# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveDecorator) do
  include ActionView::Helpers::TextHelper

  let(:decorator) { LeaveDecorator.new(object) }
  let(:current_date) { Date.current }
  let(:employee) { create(:employee) }
  let(:manager) { employee.manager }
  let(:leave_type) { create(:leave_type) }
  let(:leave_balance) { create(:leave_balance, employee:, leave_type:) }
  let(:object) do
    build(:leave, leave_type:, employee:, manager:, start_date: current_date, end_date: current_date, number_of_days: 1)
  end

  it "can get format dates" do
    expect(decorator.format_dates).to(eq(object.start_date.to_fs(:common_date)))
  end

  it "can get the description" do
    value = "#{leave_type.name} (1 day)"
    expect(decorator.description).to(eq(value))
  end

  it "can get the truncate note" do
    expect(decorator.truncate_note).to(eq(truncate(object.note, length: 40)))
  end

  it "can get the status badge" do
    expect(decorator.approval_status_badge).to(eq("default".to_sym))
  end

  it "can get the approval status title" do
    expect(decorator.approval_status_title).to(eq("Pending"))
  end

  it "can get the total days" do
    value = "-#{pluralize(object.number_of_days.to_i, "day")}"
    expect(decorator.total_days).to(eq(value))
  end
end
