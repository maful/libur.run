# frozen_string_literal: true

require "rails_helper"

RSpec.describe(BadgeComponent, type: :component) do
  let(:title) { "Verified" }

  it "renders default variant" do
    render_inline(described_class.new(title:, status: :default))
    expect(page).to(have_css("span.badge.badge--gray.badge--medium", text: title))
  end

  it "renders error variant" do
    render_inline(described_class.new(title:, status: :error))
    expect(page).to(have_css("span.badge.badge--error.badge--medium", text: title))
  end

  it "renders warning variant" do
    render_inline(described_class.new(title:, status: :warning))
    expect(page).to(have_css("span.badge.badge--warning.badge--medium", text: title))
  end

  it "renders success variant" do
    render_inline(described_class.new(title:, status: :success))
    expect(page).to(have_css("span.badge.badge--success.badge--medium", text: title))
  end

  it "renders outline indigo variant" do
    render_inline(described_class.new(title:, status: "outline-indigo"))
    expect(page).to(have_css("span.badge.badge--outline-indigo.badge--medium", text: title))
  end

  it "renders small size" do
    render_inline(described_class.new(title:, size: :small))
    expect(page).to(have_css("span.badge.badge--gray.badge--small", text: title))
  end

  it "renders medium size" do
    render_inline(described_class.new(title:))
    expect(page).to(have_css("span.badge.badge--gray.badge--medium", text: title))
  end

  it "renders large size" do
    render_inline(described_class.new(title:, size: :large))
    expect(page).to(have_css("span.badge.badge--gray.badge--large", text: title))
  end

  it "renders custom attribute" do
    render_inline(described_class.new(title:, "test-id": "random"))
    expect(page).to(have_css("span.badge.badge--gray.badge--medium[test-id='random']", text: title))
  end

  it "renders custom classes" do
    render_inline(described_class.new(title:, status: :success, classes: "ml-2"))
    expect(page).to(have_css("span.badge.badge--success.badge--medium.ml-2", text: title))
  end
end
