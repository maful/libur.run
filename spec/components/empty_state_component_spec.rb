# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EmptyStateComponent, type: :component) do
  it "renders empty state" do
    render_inline(described_class.new(title: "No Users, yet.")) do |c|
      c.with_description { "No users in your company, yet! Start adding your team here." }
    end
    expect(page).to(have_css("h1.empty-state__title", text: "No Users, yet."))
  end
end
