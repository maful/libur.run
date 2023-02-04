# frozen_string_literal: true

require "rails_helper"

RSpec.describe(BadgeComponent, type: :component) do
  describe "badge" do
    let(:title) { "Verified" }

    it "renders default" do
      result = render_inline(described_class.new(title:))

      content = result.at_css("span[class='badge badge--gray badge--medium']").content
      expect(content.delete(" \t\r\n")).to(include(title))
    end

    it "renders small variant" do
      result = render_inline(described_class.new(title:, size: :small))

      content = result.at_css("span[class='badge badge--gray badge--small']").content
      expect(content.delete(" \t\r\n")).to(eq(title))
    end

    it "renders success variant" do
      result = render_inline(described_class.new(title:, status: :success))

      content = result.at_css("span[class='badge badge--success badge--medium']").content
      expect(content.delete(" \t\r\n")).to(eq(title))
    end

    it "renders with custom classes" do
      result = render_inline(described_class.new(title:, status: :success, classes: "ml-2"))

      content = result.at_css("span[class='badge badge--success badge--medium ml-2']").content
      expect(content.delete(" \t\r\n")).to(eq(title))
    end
  end
end
