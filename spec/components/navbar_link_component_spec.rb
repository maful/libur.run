# frozen_string_literal: true

require "rails_helper"

RSpec.describe(NavbarLinkComponent, type: :component) do
  it "renders link" do
    with_request_url "/home" do
      result = render_inline(described_class.new(title: "Users", path: "/users"))

      expect(result.css("a").to_html).to(include("Users"))
    end
  end
end
