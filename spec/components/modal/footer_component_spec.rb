# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/DescribedClass
RSpec.describe(Modal::FooterComponent, type: :component) do
  it "renders default" do
    render_in_view_context do
      render(Modal::FooterComponent.new) { tag.div("Actions") }
    end
    expect(page).to(have_selector("div.modal__footer", text: "Actions"))
  end

  it "renders without content" do
    render_in_view_context do
      render(Modal::FooterComponent.new)
    end
    expect(page).not_to(have_selector("div.modal__footer"))
  end
end
# rubocop:enable RSpec/DescribedClass
