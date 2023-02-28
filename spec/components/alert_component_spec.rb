# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AlertComponent, type: :component) do
  let(:message) { "Alert" }

  it "renders default" do
    render_inline(described_class.new) { message }
    expect(page).to(have_css("div.alert.alert--info", text: message))
  end

  it "renders error status" do
    render_inline(described_class.new(status: :error)) { message }
    expect(page).to(have_css("div.alert.alert--error", text: message))
  end

  it "renders success status" do
    render_inline(described_class.new(status: :success)) { message }
    expect(page).to(have_css("div.alert.alert--success", text: message))
  end

  it "renders warning status" do
    render_inline(described_class.new(status: :warning)) { message }
    expect(page).to(have_css("div.alert.alert--warning", text: message))
  end

  it "renders custom attributes" do
    render_inline(described_class.new("test-id": "random", id: "custom-alert")) { message }
    expect(page).to(have_css("div.alert.alert--info", text: message))
    expect(page).to(have_selector("div#custom-alert[test-id='random']"))
  end

  it "renders custom classes" do
    render_inline(described_class.new(classes: ["bg-green text-md"])) { message }
    expect(page).to(have_css("div.alert.alert--info.bg-green.text-md", text: message))
  end

  it "renders dismissable" do
    render_inline(described_class.new(status: :success, dismissable: true)) { message }
    within("div.alert.alert--success") do
      expect(page).to(have_content(message))
      expect(page).to(have_selector("button.alert__button[aria-label='Close']"))
    end
  end
end
