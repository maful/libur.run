# frozen_string_literal: true

require "rails_helper"

RSpec.describe(NavbarLinkComponent, type: :component) do
  it "renders link" do
    with_request_url "/home" do
      render_inline(described_class.new(title: "Users", path: "/users"))
      expect(page).to(have_selector("a", text: "Users"))
    end
  end
end
