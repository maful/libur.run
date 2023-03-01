# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveDecorator) do
  include ActionView::Helpers::TextHelper

  let(:decorator) { described_class.new(object) }
  let(:start_date) { Date.current }
  let(:end_date) { start_date }
  let(:note) { Faker::Lorem.sentence(word_count: 10) }
  let(:employee) { create(:employee) }
  let(:manager) { employee.manager }
  let(:leave_type) { create(:leave_type) }
  let(:leave_balance) { create(:leave_balance, employee:, leave_type:) }
  let(:object) do
    create(:leave, leave_type:, employee:, manager:, start_date:, end_date:, note:)
  end

  around do |example|
    travel_to(Time.zone.local(2023, 2)) { example.run }
  end

  context "format dates for the same date" do
    it { expect(decorator.format_dates).to(eq(object.start_date.to_fs(:common_date))) }
  end

  context "format dates for the same month" do
    let(:end_date) { start_date + 1.day }
    let(:expected) { "#{start_date.strftime("%d")} - #{end_date.to_fs(:common_date)}" }

    it { expect(decorator.format_dates).to(eq(expected)) }
  end

  context "format dates for the same year" do
    let(:start_date) { Date.new(2023, 2, 28) }
    let(:end_date) { start_date + 3.days }
    let(:expected) { "#{start_date.strftime("%d %B")} - #{end_date.to_fs(:common_date)}" }

    it { expect(decorator.format_dates).to(eq(expected)) }
  end

  context "format dates for different year" do
    let(:start_date) { Date.new(2023, 12, 31) }
    let(:end_date) { start_date + 3.days }
    let(:expected) { "#{start_date.to_fs(:common_date)} - #{end_date.to_fs(:common_date)}" }

    it { expect(decorator.format_dates).to(eq(expected)) }
  end

  it "can get the full day description" do
    value = "#{leave_type.name} (1 day)"
    expect(decorator.description).to(eq(value))
  end

  context "can get the half-day description" do
    let(:object) do
      create(:leave, :half_day, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end
    let(:expected) { "#{leave_type.name} (half-day #{object.half_day_time})" }

    it { expect(decorator.description).to(eq(expected)) }
  end

  it "can get the truncate note" do
    expect(decorator.truncate_note).to(eq(truncate(object.note, length: 40)))
  end

  context "when note is empty" do
    let(:note) { nil }

    it { expect(decorator.truncate_note).to(eq("-")) }
  end

  it "when note is empty" do
    expect(decorator.truncate_note).to(eq(truncate(object.note, length: 40)))
  end

  it "can get the approval status title" do
    expect(decorator.approval_status_title).to(eq("Pending"))
  end

  it "can get the total days of full day leave" do
    value = "-#{pluralize(object.number_of_days.to_i, "day")}"
    expect(decorator.total_days).to(eq(value))
  end

  context "can get the total days of half-day leave" do
    let(:object) do
      create(:leave, :half_day, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end

    it { expect(decorator.total_days).to(eq("-0.5 day")) }
  end

  context "can get approved badge" do
    let(:object) do
      create(:leave, :approved, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end

    it { expect(decorator.approval_status_badge).to(eq("success".to_sym)) }
  end

  context "can get denied badge" do
    let(:object) do
      create(:leave, :denied, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end

    it { expect(decorator.approval_status_badge).to(eq("error".to_sym)) }
  end

  context "can get canceled badge" do
    let(:object) do
      create(:leave, :canceled, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end

    it { expect(decorator.approval_status_badge).to(eq("warning".to_sym)) }
  end

  context "can get taken badge" do
    let(:object) do
      create(:leave, :taken, leave_type:, employee:, manager:, start_date:, end_date:, note:)
    end

    it { expect(decorator.approval_status_badge).to(eq("outline-indigo".to_sym)) }
  end

  context "can get pending badge" do
    it { expect(decorator.approval_status_badge).to(eq("default".to_sym)) }
  end
end
