# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimGroupDecorator) do
  let(:decorator) { ClaimGroupDecorator.new(object) }
  let(:object) { create(:claim_group, :approved) }

  it "can get submission date" do
    expect(decorator.submission_at).to(eq(object.submission_date.to_fs(:common_date_time)))
  end

  it "can get status badge" do
    expect(decorator.status_badge).to(eq("success".to_sym))
  end
end
