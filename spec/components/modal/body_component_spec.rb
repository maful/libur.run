# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Modal::BodyComponent, type: :component) do
  it "renders default" do
    render_in_view_context do
      render(Modal::BodyComponent.new) { tag.div("Body") }
    end
    expect(page).to(have_selector("div.modal__body", text: "Body"))
  end

  it "renders without content" do
    render_in_view_context do
      render(Modal::BodyComponent.new)
    end
    expect(page).not_to(have_selector("div.modal__body"))
  end
end
