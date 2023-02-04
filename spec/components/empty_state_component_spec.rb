# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EmptyStateComponent, type: :component) do
  it "renders empty state" do
    result = render_inline(described_class.new(title: "No Users, yet.")) do |c|
      c.with_description { "No users in your company, yet! Start adding your team here." }
    end

    expect(result.css("h1").to_html).to(include("No Users, yet."))
  end
end
