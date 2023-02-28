# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Modal::HeaderComponent, type: :component) do
  it "renders default" do
    render_inline(described_class.new(title: "Title", icon: "bolt"))
    expect(page).to(have_selector("div.modal__featured-icon"))
    expect(page).to(have_selector("h1.modal__title", text: "Title"))
  end

  it "renders with description text" do
    render_inline(described_class.new(title: "Title", icon: "bolt")) do |c|
      c.with_supporting_text { "description text" }
    end
    expect(page).to(have_selector("h1.modal__title", text: "Title"))
    expect(page).to(have_selector("p.modal__help", text: "description text"))
  end

  it "renders without title" do
    render_inline(described_class.new(title: "", icon: "bolt"))
    expect(page).not_to(have_selector("div.modal__header"))
  end
end
