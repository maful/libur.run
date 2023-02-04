# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ClaimDecorator) do
  let(:decorator) { ClaimDecorator.new(object) }
  let(:object) { create(:claim) }

  it "can get issue date" do
    expect(decorator.issued_at).to(eq(object.issue_date.to_fs(:common_date)))
  end
end
