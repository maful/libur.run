# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimTypeDecorator) do
  let(:decorator) { ClaimTypeDecorator.new(object) }
  let(:object) { create(:claim_type) }

  it "can get the status title" do
    expect(decorator.status_title).to(eq("Active"))
  end

  it "can get the status badge" do
    expect(decorator.status_badge).to(eq("success".to_sym))
  end
end
