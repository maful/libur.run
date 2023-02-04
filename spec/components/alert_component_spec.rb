# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AlertComponent, type: :component) do
  describe "alert" do
    let(:message) { "Alert" }

    it "renders default" do
      result = render_inline(described_class.new.with_content(message))
      content = result.at_css("div[class='alert alert--info']").text
      expect(content.squish).to(eq(message))
    end

    it "renders error status" do
      result = render_inline(described_class.new(status: :error).with_content(message))
      content = result.at_css("div[class='alert alert--error']").text
      expect(content.squish).to(eq(message))
    end

    it "renders success status" do
      result = render_inline(described_class.new(status: :success).with_content(message))
      content = result.at_css("div[class='alert alert--success']").text
      expect(content.squish).to(eq(message))
    end

    it "renders warning status" do
      result = render_inline(described_class.new(status: :warning).with_content(message))
      content = result.at_css("div[class='alert alert--warning']").text
      expect(content.squish).to(eq(message))
    end
  end
end
