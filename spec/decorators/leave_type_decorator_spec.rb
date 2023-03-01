# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LeaveTypeDecorator) do
  let(:decorator) { described_class.new(object) }
  let(:object) { create(:leave_type) }

  context "can get active title" do
    it { expect(decorator.status_title).to(eq("Active")) }
  end

  context "can get inactive title" do
    let(:object) { create(:leave_type, :inactive) }

    it { expect(decorator.status_title).to(eq("Inactive")) }
  end

  context "can get active badge" do
    it { expect(decorator.status_badge).to(eq(:success)) }
  end

  context "can get inactive badge" do
    let(:object) { create(:leave_type, :inactive) }

    it { expect(decorator.status_badge).to(eq(:error)) }
  end
end
