# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimGroupDecorator) do
  let(:decorator) { described_class.new(object) }

  context "can get submission date" do
    let(:object) { create(:claim_group) }

    it { expect(decorator.submission_at).to(eq(object.submission_date.to_fs(:common_date_time))) }
  end

  context "can get approved badge" do
    let(:object) { create(:claim_group, :approved) }

    it { expect(decorator.status_badge).to(eq("success".to_sym)) }
  end

  context "can get completed badge" do
    let(:object) { create(:claim_group, :completed) }

    it { expect(decorator.status_badge).to(eq("outline-indigo".to_sym)) }
  end

  context "can get denied badge" do
    let(:object) { create(:claim_group, :denied) }

    it { expect(decorator.status_badge).to(eq("error".to_sym)) }
  end

  context "can get canceled badge" do
    let(:object) { create(:claim_group, :canceled) }

    it { expect(decorator.status_badge).to(eq("warning".to_sym)) }
  end

  context "can get pending badge" do
    let(:object) { create(:claim_group) }

    it { expect(decorator.status_badge).to(eq("default".to_sym)) }
  end
end
