# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AccountDecorator) do
  let(:decorator) { AccountDecorator.new(object) }
  let(:object) { create(:account) }

  it "can get status badge" do
    expect(decorator.status_badge).to(eq("success".to_sym))
  end
end
