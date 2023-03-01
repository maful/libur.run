# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AccountDecorator) do
  it "can get success badge" do
    account = create(:account)
    expect(AccountDecorator.new(account).status_badge).to(eq("success".to_sym))
  end

  it "can get warning badge" do
    account = create(:account, :unverified)
    expect(AccountDecorator.new(account).status_badge).to(eq("warning".to_sym))
  end

  it "can get error badge" do
    account = create(:account, :closed)
    expect(AccountDecorator.new(account).status_badge).to(eq("error".to_sym))
  end
end
